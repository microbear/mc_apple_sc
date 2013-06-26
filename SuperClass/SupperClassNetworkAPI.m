//
//  SupperClassNetworkAPI.m
//  SuperClass
//
//  Created by xiongwei on 13-6-10.
//
//

#import "SupperClassNetworkAPI.h"

@implementation SupperClassNetworkAPI

@synthesize HUD = _HUD;


static SupperClassNetworkAPI *sharedInstance;

+ (SupperClassNetworkAPI *)sharedInstance
{
	return sharedInstance;
}
+ (void) initialize
{
    static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;

        //creat the sqlite file
        NSError *error = nil;
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
        if (! success) {
            RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
        }
        [managedObjectStore createPersistentStoreCoordinator];

        NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
        NSLog(@"%@", path);
        NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
        if (! persistentStore) {
            RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
        }
        [managedObjectStore createManagedObjectContexts];
        
        //creat manager
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:MAIN_PATH]];
        manager.managedObjectStore = managedObjectStore;
        managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        
        //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        sharedInstance = [[SupperClassNetworkAPI alloc] init];
    }


}

-(NSFetchedResultsController *)fetchResult:(NSString *)entityName sortKey:(NSString *)sortKey
{
    //creat fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *sortWithUniqueID = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES];
    fetchRequest.sortDescriptors = @[sortWithUniqueID];
    NSError *error = nil;
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    BOOL fetchSuccessful = [fetchedResultsController performFetch:&error];
    if (! fetchSuccessful)
    {
        RKLogError(@"Failed to fetch entity:%@ at path:'%@' error:%@", entityName,RKApplicationDataDirectory(), error);
        return nil;
    }
    return fetchedResultsController;

}

-(void)loadObject:(NSString *)entityName sort_key:(NSString *)sortKey atPath:(NSString *)path withMapping:(RKEntityMapping *)mapping param:(NSDictionary *)paramDic fail_fetch:(BOOL)still_fetch complete:(void(^)(BOOL complete, BOOL success, NSFetchedResultsController* fetchResultController))completeHandle
{

    [MBProgressHUD showHUDAddedTo:[self applicationWindow] animated:YES];

    //configure RKObjectManager
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:paramDic success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [MBProgressHUD hideHUDForView:[self applicationWindow] animated:YES];
        
        NSLog(@"load entity:%@ from network success!\n", entityName);
        NSFetchedResultsController *fetchedResultsController = [self fetchResult:entityName sortKey:sortKey];
        completeHandle(YES, YES,fetchedResultsController);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        if (operation.HTTPRequestOperation.response.statusCode == 400)
        {
            [MBProgressHUD hideHUDForView:[self applicationWindow] animated:YES];

            NSLog(@"load entity:%@ from network fail! error:%@\n", entityName, error);
            NSFetchedResultsController *fetchedResultsController = nil;
            if (still_fetch)
            {
                fetchedResultsController = [self fetchResult:entityName sortKey:sortKey];
                
            }
            completeHandle(YES, NO, fetchedResultsController);

        }
        else
        {
            [MBProgressHUD hideHUDForView:[self applicationWindow] animated:YES];

            [self showInformation:nil info:@"网络连接错误！"];
        }
        
    }];


}

+ (void) loadUserInfo:(NSDictionary *)paramDic completeBlock:(void(^)(BOOL complete, BOOL success, NSFetchedResultsController* fetchResultController))completeHandle
{
    //creat responseDescriptor
    NSString *entity_name = @"UserInfo";
    NSString *sort_key = @"userID";
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:entity_name inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{ @"id": @"userID", @"name": @"username" }];
    
    RKEntityMapping* statusMapping = [RKEntityMapping mappingForEntityForName:@"Status" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [statusMapping addAttributeMappingsFromArray:@[ @"created_at", @"text" ]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                                            toKeyPath:@"status"
                                                                          withMapping:statusMapping]];
    mapping.identificationAttributes = @[ sort_key ];
    
    //NSDictionary *paramDic = @{@"uid":@2100396861, @"access_token":SINA_WEIBO_ACCESSTOKEN};
    SupperClassNetworkAPI *instance = [SupperClassNetworkAPI sharedInstance];
    [instance loadObject:entity_name sort_key:sort_key atPath:USER_INFO_RELATIVE_PATH withMapping:mapping param:paramDic fail_fetch:NO complete:completeHandle];
    
}

+ (void) loadUserInfo:(void(^)(BOOL complete, BOOL success, NSFetchedResultsController* fetchResultController))completeHandle
{
    //creat responseDescriptor
    NSString *entity_name = @"UserInfo";
    NSString *sort_key = @"userID";
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:entity_name inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{ @"id": @"userID", @"name": @"username" }];
    
    RKEntityMapping* statusMapping = [RKEntityMapping mappingForEntityForName:@"Status" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [statusMapping addAttributeMappingsFromArray:@[ @"created_at", @"text" ]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                                                   toKeyPath:@"status"
                                                                                 withMapping:statusMapping]];
    mapping.identificationAttributes = @[ sort_key ];

    NSDictionary *paramDic = @{@"uid":@2100396861, @"access_token":SINA_WEIBO_ACCESSTOKEN};
    SupperClassNetworkAPI *instance = [SupperClassNetworkAPI sharedInstance];

    [instance loadObject:entity_name sort_key:sort_key atPath:USER_INFO_RELATIVE_PATH withMapping:mapping param:paramDic fail_fetch:NO complete:completeHandle];

}

#pragma -mark network indicator

-(UIView *) applicationWindow
{
    return [[UIApplication sharedApplication].delegate window];
}
- (void)showInformation:(UIView *)view info:(NSString *)info {
    if (self.HUD) {
        [self.HUD removeFromSuperview];
    }
    
    if (view == nil) {
        view = [self applicationWindow];
    }
    
    if (self.HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
        
        
        if ([info length] > 12) {
            self.HUD.detailsLabelText = info;
            self.HUD.detailsLabelFont = [UIFont systemFontOfSize:16];
        }
        else {
            self.HUD.labelText = info;
            self.HUD.labelFont = [UIFont systemFontOfSize:18];
        }
    }
    
    if ([view isKindOfClass:[UIWindow class]]) {
        [view addSubview:self.HUD];
    }
    else {
        [view.window addSubview:self.HUD];
    }
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1.0];
}


//- (void) loadUserInfo:(void(^)(BOOL complete))completeHandle
//{
//    //creat responseDescriptor
//    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"UserInfo" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
//    [mapping addAttributeMappingsFromDictionary:@{ @"id": @"userID", @"name": @"username" }];
//    mapping.identificationAttributes = @[ @"userID" ];
//    
//    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:statusCodes];
//    
//    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
//    
//    NSDictionary *paramDic = @{@"uid":@2100396861, @"access_token":SINA_WEIBO_ACCESSTOKEN};
//    [[RKObjectManager sharedManager] getObjectsAtPath:USER_INFO_RELATIVE_PATH parameters:paramDic success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        
//        NSLog(@"load userinfo success\n");
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
//        NSSortDescriptor *sortWithUniqueID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
//        fetchRequest.sortDescriptors = @[sortWithUniqueID];
//        
//        NSError *error = nil;
//        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                                                   managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
//                                                                                                     sectionNameKeyPath:nil
//                                                                                                              cacheName:nil];
//        BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
//        NSLog(@"count = %d", [[self.fetchedResultsController fetchedObjects] count]);
//        NSAssert([[self.fetchedResultsController fetchedObjects] count], @"Seeding didn't work...");
//        if (! fetchSuccessful)
//        {
//            if (! fetchSuccessful) {
//                RKLogError(@"Failed to fetch entity:%@ at path:'%@' error:%@", @"UserInfo",RKApplicationDataDirectory(), error);
//            }
//        }
//     completeHandle(YES);
//     
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"load userinfo error\n");
//
//        
//    }];
//    
//
//}
//- (void) fetchUserInfo
//{
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
//    NSSortDescriptor *sortWithUniqueID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
//    fetchRequest.sortDescriptors = @[sortWithUniqueID];
//    
//    NSError *error = nil;
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                        managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
//                                                                          sectionNameKeyPath:nil
//                                                                                   cacheName:nil];
//    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
//    NSLog(@"count = %d", [[self.fetchedResultsController fetchedObjects] count]);
//    //NSAssert([[fetchedResultsController fetchedObjects] count], @"Seeding didn't work...");
//    if (! fetchSuccessful)
//    {
//        NSLog(@"fetch userinfo error!");
//    }
//
//}





@end

//
//  ViewController.m
//  SuperClass
//
//  Created by xiongwei on 13-5-29.
//
//

#import "ViewController.h"
#import "UserInfo_coredata.h"
#import "SupperClassNetworkAPI.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SupperClassNetworkAPI sharedInstance] loadUserInfo:^(BOOL complete, NSFetchedResultsController *result_controller){
        if (complete)
        {
            self.fetchedResultsController = result_controller;
            self.fetchedResultsController.delegate = self;
            NSLog(@"fetched userinfo count = %d", [[self.fetchedResultsController fetchedObjects] count]);
        }
    }];
    //[self test_RestKit_coredata];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //merge in different file
    //merge in same file
    // Dispose of any resources that can be recreated.
}


#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView reloadData];
}


#pragma -mark test
-(void) RKTwitterShowAlert:(NSError *)error withTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) test_RestKit_coredata
{
    //using my sina weibo to test the RestKit
    //to creat the sina weibo's accesstoken, you should creat your sina's app,and run the sinaweibo's SDK demo.
    //To known more, please refer to "http://open.weibo.com/wiki/SDK"
    //
#define  SINA_WEIBO_USERID      @"2100396861"
#define  SINA_WEIBO_ACCESSTOKEN @"2.00jKDJSC9UyzcEc62f3a99c8aLvbmB"
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    
    //1.creat the sqlite file
    NSError *error = nil;
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
    NSLog(@"%@", path);
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    //2.creat responseDescriptor
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"UserInfo" inManagedObjectStore:managedObjectStore];
    [mapping addAttributeMappingsFromDictionary:@{ @"id": @"userID", @"name": @"username" }];
    mapping.identificationAttributes = @[ @"userID" ];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    //3.intergrate with the object manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://api.weibo.com"]];
    manager.managedObjectStore = managedObjectStore;
    [manager addResponseDescriptor:responseDescriptor];
    
    //4.perform the sina weibo “users/show” API
    //please refer to http://open.weibo.com/wiki/2/users/show
    NSDictionary *paramDic = @{@"uid":@2100396861, @"access_token":SINA_WEIBO_ACCESSTOKEN};
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/2/users/show.json" parameters:paramDic success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        //5.fetch the result from the core data
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
        NSSortDescriptor *sortWithUniqueID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
        fetchRequest.sortDescriptors = @[sortWithUniqueID];
        
        NSError *error = nil;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        [self.fetchedResultsController setDelegate:self];
        BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
        NSAssert([[self.fetchedResultsController fetchedObjects] count], @"Seeding didn't work...");
        if (! fetchSuccessful) {
            [self RKTwitterShowAlert:error withTitle:@"error" message:[error description]];
        }
        NSArray *fetchResult = [self.fetchedResultsController fetchedObjects];
        UserInfo_coredata* core_object = [fetchResult lastObject];
        [self RKTwitterShowAlert:nil withTitle:@"username" message:core_object.username];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

        // Transport error or server error handled by errorDescriptor
    }];
    
#undef SINA_WEIBO_USERID
#undef SINA_WEIBO_ACCESSTOKEN
    
    
}



@end

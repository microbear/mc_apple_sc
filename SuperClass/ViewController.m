//
//  ViewController.m
//  SuperClass
//
//  Created by xiongwei on 13-5-29.
//
//

#import "ViewController.h"
#import "UserInfo.h"
#import "Status.h"
#import "SupperClassNetworkAPI.h"
#import "RegisterViewController.h"
#import "CourseCategoryViewController.h"

@interface ViewController ()
{
    
}
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) UIImageView *test_imageview;
@end

@implementation ViewController
@synthesize test_imageview = _test_imageview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*******************for test********************/
    //[self test_RestKit_coredata];
    [self test_load_image];
    /***********************************************/
    
    self.password_textfield.delegate = self;
    self.username_textfield.delegate = self;
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark MBProgressHUD


#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView reloadData];
}



#pragma mark outlet action


- (IBAction)register_user:(UIButton *)sender
{
    RegisterViewController *register_viewcontroller = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:register_viewcontroller animated:YES completion:nil];
}


-(void) load_userinfo:(NSDictionary *)param
{
    [SupperClassNetworkAPI loadUserInfo:param completeBlock:^(BOOL complete, BOOL success, NSFetchedResultsController *fetchResultController) {
        if (complete)
        {
            if (success)
            {

                self.fetchedResultsController = fetchResultController;
                self.fetchedResultsController.delegate = self;
                NSLog(@"fetched userinfo count = %d", [[self.fetchedResultsController fetchedObjects] count]);
                UserInfo *user = (UserInfo *)[[self.fetchedResultsController fetchedObjects] lastObject];
                NSLog(@"name:%@ status:%@", user.username, user.status.text);
                
                CourseCategoryViewController *courseCategoryViewController = [[CourseCategoryViewController alloc] initWithNibName:nil bundle:nil];
                courseCategoryViewController.fetchedResultsController = self.fetchedResultsController;
                [self presentViewController:courseCategoryViewController animated:YES completion:nil];
                
            }
            
        }
    }];

}

- (IBAction)login:(UIButton *)sender
{

    self.username = self.username_textfield.text;
    //NSNumber *uid = [NSNumber numberWithInt:[self.username intValue]];
    NSDictionary *user_params = @{@"uid":SINA_WEIBO_USERID, @"access_token":SINA_WEIBO_ACCESSTOKEN};
    [self load_userinfo:user_params];
    

}



#pragma mark UITextfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断用户名是否太长
    if (textField == self.username_textfield && textField.text.length >= USERNAME_MAX_LENGTH && range.length == 0) {
        return NO;
    }
    //判断密码是否太长
    if (textField == self.password_textfield && textField.text.length >= PASSWORD_MAX_LENGTH && range.length == 0) {
        return NO;
    }
    
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.username_textfield) {
		[textField resignFirstResponder];
		[self.password_textfield becomeFirstResponder];
	}
	else if (textField == self.password_textfield)
    {
		[textField resignFirstResponder];
        [self login:nil];
	}
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.username_textfield resignFirstResponder];
    [self.password_textfield resignFirstResponder];
}










#pragma -mark test

-(void) test_load_image
{
    
    self.test_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 100.0f, 100.0f)];
    
    [self.view addSubview:self.test_imageview];
    
    [SupperClassNetworkAPI load_image:IMAGE_TEST_URL complete_handle:^(BOOL success, UIImage *image){
        
        if (success) {
            self.test_imageview.image = image;
        }
    }];

}


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
        UserInfo* core_object = [fetchResult lastObject];
        [self RKTwitterShowAlert:nil withTitle:@"username" message:core_object.username];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

        // Transport error or server error handled by errorDescriptor
    }];
    
#undef SINA_WEIBO_USERID
#undef SINA_WEIBO_ACCESSTOKEN
    
    
}



@end

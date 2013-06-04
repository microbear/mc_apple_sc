//
//  AppDelegate.m
//  SuperClass
//
//  Created by xiongwei on 13-5-29.
//
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "MyCustomLogFormatter.h"
#import "UserInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //DDlog initial
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setLogFormatter:[[MyCustomLogFormatter alloc] init]];
    
    //[self test_RestKit];
    
    //shareSDK initial
    //[ShareSDK registerApp:@"SCTest"];
    //[self initializePlat];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma -mark ShareSDK
- (void)initializePlat
{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"4240802632"
                               appSecret:@"a7d7a03994b6a1bc044a7e44f16726c7" redirectUri:@"http://blog.sina.com.cn/u/2100396861"];
}

#pragma -mark Restkit
//test pull
-(void) test_RestKit
{
    //using my sina weibo to test the RestKit
    //to creat the sina weibo's accesstoken, you should creat your sina's app,and run the sinaweibo's SDK demo.
    //To known more, please refer to "http://open.weibo.com/wiki/SDK"
    //
#define  SINA_WEIBO_USERID      @"2100396861"
#define  SINA_WEIBO_ACCESSTOKEN @"2.00jKDJSC9UyzcEc62f3a99c8aLvbmB"
   
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"name":   @"username",
     @"id":     @"userID",
     }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:nil];
    
    // Add our descriptors to the manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://api.weibo.com"]];
    [manager addResponseDescriptorsFromArray:@[responseDescriptor]];
    
    NSDictionary *paramDic = @{@"uid":@2100396861, @"access_token":SINA_WEIBO_ACCESSTOKEN};
    [manager getObjectsAtPath:@"/2/users/show.json" parameters:paramDic success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *result_array = [mappingResult array];
        UserInfo *user = (UserInfo*)[result_array lastObject];
        NSLog(@"user id:%@", user.userID);
        NSLog(@"user name:%@", user.username);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
    }];
    
#undef SINA_WEIBO_USERID
#undef SINA_WEIBO_ACCESSTOKEN

    
}


@end

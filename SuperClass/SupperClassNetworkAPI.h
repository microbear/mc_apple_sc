//
//  SupperClassNetworkAPI.h
//  SuperClass
//
//  Created by xiongwei on 13-6-10.
//
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "Status.h"
#import "MBProgressHUD.h"

#define  SINA_WEIBO_USERID          @"2100396861"
#define  SINA_WEIBO_ACCESSTOKEN     @"2.00jKDJSC9UyzcEc62f3a99c8aLvbmB"

#define MAIN_PATH                   @"https://api.weibo.com" //服务器主地址

#define USER_INFO_RELATIVE_PATH     @"/2/users/show.json"
#define IMAGE_TEST_URL              @"http://i.imgur.com/r4uwx.jpg"
@interface SupperClassNetworkAPI : NSObject
{
}
@property (nonatomic, strong) MBProgressHUD *HUD;

+ (void)showInformation:(UIView *)view info:(NSString *)info;

+ (SupperClassNetworkAPI *)sharedInstance;

//need to initialze first
+ (void) initialize;


+ (void) loadUserInfo:(void(^)(BOOL complete, BOOL success, NSFetchedResultsController* fetchResultController))completeHandle;
+ (void) loadUserInfo:(NSDictionary *)paramDic completeBlock:(void(^)(BOOL complete, BOOL success, NSFetchedResultsController* fetchResultController))completeHandle;

//- (void) fetchUserInfo;
//- (void) getUserInfo;
//+(void) get_image:(UIView *)view;
+ (void) load_image:(NSString *)url   complete_handle:(void(^)(BOOL success, UIImage *out_image))completeHandle;


@end

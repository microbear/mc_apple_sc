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

#define  SINA_WEIBO_USERID      @"2100396861"
#define  SINA_WEIBO_ACCESSTOKEN @"2.00jKDJSC9UyzcEc62f3a99c8aLvbmB"

#define MAIN_PATH                   @"https://api.weibo.com" //服务器主地址

#define USER_INFO_RELATIVE_PATH     @"/2/users/show.json"

@interface SupperClassNetworkAPI : NSObject
{
}

//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

+ (SupperClassNetworkAPI *)sharedInstance;

//need to initialze first
+ (void) initialize;


- (void) loadUserInfo:(void(^)(BOOL complete, NSFetchedResultsController* fetchResultController))completeHandle;

//- (void) fetchUserInfo;
//- (void) getUserInfo;

@end

//
//  UserInfo_coredata.h
//  SuperClass
//
//  Created by xiongwei on 13-6-2.
//
//

#import <CoreData/CoreData.h>

@interface UserInfo_coredata : NSManagedObject
@property (nonatomic, strong) NSNumber* userID;
@property (nonatomic, strong) NSString* username;
@end

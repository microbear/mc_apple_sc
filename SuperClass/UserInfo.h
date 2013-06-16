//
//  UserInfo.h
//  SuperClass
//
//  Created by xiongwei on 13-6-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Status;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) Status *status;

@end

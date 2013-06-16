//
//  Status.h
//  SuperClass
//
//  Created by xiongwei on 13-6-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UserInfo *user;

@end

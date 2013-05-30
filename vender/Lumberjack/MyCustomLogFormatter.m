//
//  MyCustomLogFormatter.m
//  SuperClass
//
//  Created by xiongwei on 13-5-5.
//  Copyright (c) 2013年 xiongwei. All rights reserved.
//

#import "MyCustomLogFormatter.h"
@implementation MyCustomLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    
    return [NSString stringWithFormat:@"{DDlogger:file(%s),function(%s),line(%d)} %@\n", logMessage->file, logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}
@end

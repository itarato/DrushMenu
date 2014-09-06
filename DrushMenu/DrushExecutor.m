//
//  DrushExecutor.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "DrushExecutor.h"

#define DRUSH_EXECUTOR_DRUSH_PATH @"/Users/itarato/Web/drush/drush"

@implementation DrushExecutor

+ (DrushExecutor *)mainExecutor {
    static DrushExecutor *mainExecutor;
    if (mainExecutor == nil) {
        mainExecutor = [[DrushExecutor alloc] init];
    }
    return mainExecutor;
}

- (NSString *)execute:(NSString *)onPath withArgs:(NSArray *)arguments {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appBecameBusy" object:nil];
    
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryPath = onPath;
    task.launchPath = DRUSH_EXECUTOR_DRUSH_PATH;
    task.arguments = arguments;
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return output;
}

- (void)executeInBackground:(NSString *)onPath withArgs:(NSArray *)arguments {
    __block NSString *result;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        result = [self execute:onPath withArgs:arguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Main thread.
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"DrushMenu";
            notification.subtitle = @"Command execution has finished";
            // Not possible atm due to the way Drush emits its log messages through fwrite. Investigate issue.
            // notification.informativeText = [NSString stringWithFormat:@"Log: %@", result];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appBecameIdle" object:nil];
        });
    });
}

@end

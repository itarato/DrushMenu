//
//  DrushExecutor.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "DrushExecutor.h"

@implementation DrushExecutor

@synthesize drushCommandPath;

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
    task.launchPath = self.drushCommandPath;
    task.arguments = arguments;
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return output;
}

- (void)executeInBackground:(NSString *)onPath withArgs:(NSArray *)arguments andCompletion:(void (^)(void))block {
    __block NSString *result;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        result = [self execute:onPath withArgs:arguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Main thread.
            if (block != nil) {
                block();
            }
        });
    });
}

@end

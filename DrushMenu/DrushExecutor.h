//
//  DrushExecutor.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrushExecutor : NSObject

+ (DrushExecutor *)mainExecutor;

- (NSString *)execute:(NSString *)onPath withArgs:(NSArray *)arguments;
- (void)executeInBackground:(NSString *)onPath withArgs:(NSArray *)arguments andCompletion:(void(^)(void))block;

@end

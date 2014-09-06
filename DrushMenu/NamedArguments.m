//
//  NamedArguments.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "NamedArguments.h"

@implementation NamedArguments

@synthesize name;
@synthesize arguments;

- (id)initWithName:(NSString *)argName andArguments:(NSString *)firstArg, ... {
    NSMutableArray *tempArgsArray = [[NSMutableArray alloc] init];
    if (self = [super init]) {
        va_list args;
        va_start(args, firstArg);
        for (; firstArg != nil; firstArg = va_arg(args, NSString*)) {
            [tempArgsArray addObject:firstArg];
        }
        va_end(args);
        self.arguments = [NSArray arrayWithArray:tempArgsArray];
        self.name = argName;
    }
    
    return self;
}

- (id)initWithName:(NSString *)argName andArgumentArray:(NSArray *)array {
    if (self = [super init]) {
        self.name = argName;
        self.arguments = array;
    }
    
    return self;
}

@end

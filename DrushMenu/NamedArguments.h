//
//  NamedArguments.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NamedArguments : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *arguments;

- (id)initWithName:(NSString *)argName andArguments:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

@end

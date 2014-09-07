//
//  SiteConfiguration.m
//  DrushMenu
//
//  Created by Peter Arato on 9/7/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "SiteConfiguration.h"
#import "NamedArguments.h"

@interface SiteConfiguration()

- (void)parse:(NSDictionary *)dictionary;

@end

@implementation SiteConfiguration

@synthesize name;
@synthesize folder;
@synthesize extraCommands;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self parse:dictionary];
    }
    return self;
}

- (void)parse:(NSDictionary *)dictionary {
    self.name = [dictionary objectForKey:@"name"];
    self.folder = [dictionary objectForKey:@"folder"];
    NSArray *extra_commands = [dictionary objectForKey:@"extra_commands"];
    self.extraCommands = [[NSMutableArray alloc] initWithCapacity:[extra_commands count]];
    if (extra_commands != nil) {
        for (id extra_command in extra_commands) {
            [self.extraCommands addObject:[[NamedArguments alloc] initWithName:[extra_command objectForKey:@"name"] andArgumentArray:[extra_command objectForKey:@"arguments"]]];
        }
    }
}

@end

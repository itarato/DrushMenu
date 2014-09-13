//
//  SiteConfiguration.m
//  DrushMenu
//
//  Created by Peter Arato on 9/7/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "SiteConfiguration.h"
#import "NamedArguments.h"
#import "Command.h"

@interface SiteConfiguration()

- (void)parse:(NSDictionary *)dictionary;

@end

@implementation SiteConfiguration

@synthesize name;
@synthesize folder;
@synthesize commands;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self parse:dictionary];
    }
    return self;
}

- (void)parse:(NSDictionary *)dictionary {
    self.name = [dictionary objectForKey:@"name"];
    self.folder = [dictionary objectForKey:@"folder"];
    NSArray *commands_raw = [dictionary objectForKey:@"commands"];
    self.commands = [[NSMutableArray alloc] initWithCapacity:[commands_raw count]];
    if (commands_raw != nil) {
        for (id command_raw in commands_raw) {
            [self.commands addObject:[[Command alloc] initWithTitle:[command_raw objectForKey:@"name"] andArguments:[command_raw objectForKey:@"arguments"] andSiteConfiguration:self andHotkey:[command_raw objectForKey:@"hotkey"]]];
        }
    }
}

@end

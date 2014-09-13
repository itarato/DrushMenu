//
//  SiteMenuItem.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SiteConfiguration.h"

@class Command;

@interface SiteMenuItem : NSMenuItem

@property (nonatomic, retain) SiteConfiguration *site;
@property (nonatomic, retain) Command *command;

- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode site:(SiteConfiguration *)aSite andCommand:(Command *)aCommand;

@end

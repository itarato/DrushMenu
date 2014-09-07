//
//  SiteMenuItem.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SiteConfiguration.h"

@interface SiteMenuItem : NSMenuItem

@property (nonatomic, retain) SiteConfiguration *site;
@property (nonatomic, retain) NSArray *arguments;

- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode site:(SiteConfiguration *)aSite andArguments:(NSArray *)args;

@end

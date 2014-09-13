//
//  Command.h
//  DrushMenu
//
//  Created by Peter Arato on 9/13/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SiteConfiguration;

@interface Command : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *arguments;
@property (nonatomic, retain) SiteConfiguration *siteConfiguration;
@property (nonatomic, retain) NSString *hotkey;

- (id)initWithTitle:(NSString *)aTitle andArguments:(NSArray *)theArguments andSiteConfiguration:(SiteConfiguration *)aSiteConfiguration andHotkey:(NSString *)aHotkey;

- (void)onExecuteNotification:(NSNotification *)notification;

- (void)execute;

@end

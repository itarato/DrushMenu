//
//  Command.m
//  DrushMenu
//
//  Created by Peter Arato on 9/13/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "Command.h"
#import "SiteConfiguration.h"
#import "DrushExecutor.h"

@implementation Command

@synthesize title;
@synthesize arguments;
@synthesize siteConfiguration;
@synthesize hotkey;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle andArguments:(NSArray *)theArguments andSiteConfiguration:(SiteConfiguration *)aSiteConfiguration andHotkey:(NSString *)aHotkey {
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.arguments = theArguments;
        self.siteConfiguration = aSiteConfiguration;
        self.hotkey = aHotkey;
        
        if (aHotkey != nil) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExecuteNotification:) name:kDMNotificationExecutionShortcut object:nil];
        }
    }
    return self;
}

- (void)onExecuteNotification:(NSNotification *)notification {
    NSLog(@"Notification called on: %@", self);
    NSEvent *eventFromKeyHit = (NSEvent *)[notification object];
    NSNumber *keycode = [NSNumber numberWithUnsignedShort:eventFromKeyHit.keyCode];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *hotkeyNumber = [numberFormatter numberFromString:self.hotkey];
    if ([hotkeyNumber integerValue] == [keycode integerValue]) {
        [self execute];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Command - %@ (%@)", self.title, self.siteConfiguration.name];
}

- (void)execute {
    [[DrushExecutor mainExecutor] executeInBackground:self.siteConfiguration.folder withArgs:self.arguments andCompletion:^{
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"DrushMenu";
        notification.subtitle = @"Command execution has finished";
        // Not possible atm due to the way Drush emits its log messages through fwrite. Investigate issue.
        // notification.informativeText = [NSString stringWithFormat:@"Log: %@", result];
        notification.informativeText = [NSString stringWithFormat:@"Site: %@ / Task: %@", self.siteConfiguration.name, self.title];
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        // Notify others about the finish.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appBecameIdle" object:nil];
    }];
}

@end

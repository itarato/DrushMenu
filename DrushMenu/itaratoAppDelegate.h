//
//  itaratoAppDelegate.h
//  DrushMenu
//
//  Created by Peter Arato on 9/5/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface itaratoAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) NSMenu *menu;
@property (nonatomic, retain) NSImage *statusIconNormal;
@property (nonatomic, retain) NSImage *statusIconWait;

- (void)didSelectDrushMenuItem:(NSMenuItem *)sender;
- (void)selectConfigurationFile:(NSMenuItem *)sender;

- (void)loadConfigurationFile;
- (void)approveConfigurationFromURL:(NSURL *)url;

- (void)didAppBecameBusy:(NSNotification *)notification;
- (void)didAppBecameIdle:(NSNotification *)notification;

@end

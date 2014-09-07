//
//  itaratoAppDelegate.m
//  DrushMenu
//
//  Created by Peter Arato on 9/5/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "itaratoAppDelegate.h"
#import "SiteMenuItem.h"
#import "NamedArguments.h"
#import "DrushExecutor.h"
#import "MenuBuilder.h"
#import "AppConfiguration.h"

@implementation itaratoAppDelegate

@synthesize statusItem;
@synthesize menu;
@synthesize statusIconNormal;
@synthesize statusIconWait;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Set user notification delegate.
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    // Set status bar item.
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:24.0f];
    
    statusIconNormal = [NSImage imageNamed:@"toolbar_icon.png"];
    statusIconWait = [NSImage imageNamed:@"toolbar_icon_wait.png"];
    
    [statusItem setImage:statusIconNormal];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    
    // Add main menu.
    menu = [[NSMenu alloc] initWithTitle:@"Drush commands"];
    
    NSMenuItem *configMenuItem = [[NSMenuItem alloc] initWithTitle:@"Configuration" action:@selector(selectConfigurationFile:) keyEquivalent:@"s"];
    [menu addItem:configMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
 
    [statusItem setMenu:menu];

    // Load configuration.
    if ([[AppConfiguration mainConfig] loadFromSave]) {
        [self approveConfiguration];
    } else {
        [self loadConfigurationFile];
    }
    
    // Setup global event listeners.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppBecameBusy:) name:@"appBecameBusy" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppBecameIdle:) name:@"appBecameIdle" object:nil];
}

- (void)didAppBecameBusy:(NSNotification *)notification {
    [self.statusItem setImage:statusIconWait];
}

- (void)didAppBecameIdle:(NSNotification *)notification {
    [self.statusItem setImage:statusIconNormal];
}

- (void)didSelectDrushMenuItem:(SiteMenuItem *)sender {
    [[DrushExecutor mainExecutor] executeInBackground:sender.site.folder withArgs:[sender arguments] andCompletion:^{
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"DrushMenu";
        notification.subtitle = @"Command execution has finished";
        // Not possible atm due to the way Drush emits its log messages through fwrite. Investigate issue.
        // notification.informativeText = [NSString stringWithFormat:@"Log: %@", result];
        notification.informativeText = [NSString stringWithFormat:@"Site: %@ / Task: %@", sender.site.name, sender.title];
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        // Notify others about the finish.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appBecameIdle" object:nil];
    }];
}

- (void)selectConfigurationFile:(NSMenuItem *)sender {
    [self loadConfigurationFile];
}

- (void)loadConfigurationFile {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel runModal];
    
    NSURL *url = [openPanel URL];
    if (url == nil) {
        return;
    }
    
    // Load JSON.
    NSError *error;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:&error];
    
    if (error != nil) {
        NSLog(@"Error when attempted to open file.");
        return;
    }
    
    // Parse JSON into config object.
    NSData *configData = [fileHandle readDataToEndOfFile];
    [[AppConfiguration mainConfig] loadFromData:configData];
    [[AppConfiguration mainConfig] save];
    
    [self approveConfiguration];
}

- (void)approveConfiguration {
    AppConfiguration *appConfig = [AppConfiguration mainConfig];
    
    [[DrushExecutor mainExecutor] setDrushCommandPath:appConfig.drushPath];
    
    [[MenuBuilder mainBuilder] fromAppConfiguration:appConfig onMenu:[self menu] usingAction:@selector(didSelectDrushMenuItem:)];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end

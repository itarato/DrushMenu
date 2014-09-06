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

#define IS_DEV YES

@implementation itaratoAppDelegate

@synthesize statusItem;
@synthesize menu;
@synthesize statusIconNormal;
@synthesize statusIconWait;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:24.0f];
    
    statusIconNormal = [NSImage imageNamed:@"toolbar_icon.png"];
    statusIconWait = [NSImage imageNamed:@"toolbar_icon_wait.png"];
    
    [statusItem setImage:statusIconNormal];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    
    menu = [[NSMenu alloc] initWithTitle:@"Drush commands"];
    
    NSMenuItem *configMenuItem = [[NSMenuItem alloc] initWithTitle:@"Configuration" action:@selector(selectConfigurationFile:) keyEquivalent:@"s"];
    [menu addItem:configMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
 
    [statusItem setMenu:menu];

    if (IS_DEV) {
        [self approveConfigurationFromURL:[NSURL URLWithString:@"/Users/itarato/Documents/drush.json"]];
    } else {
        [self loadConfigurationFile];
    }
    
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
    [[DrushExecutor mainExecutor] executeInBackground:[sender getPath] withArgs:[sender arguments]];
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
    [self approveConfigurationFromURL:url];
}

- (void)approveConfigurationFromURL:(NSURL *)url {
    [[MenuBuilder mainBuilder] fromConfigurationFileURL:url onMenu:[self menu] usingAction:@selector(didSelectDrushMenuItem:)];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end

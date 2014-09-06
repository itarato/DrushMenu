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

#define IS_DEV YES

@implementation itaratoAppDelegate

@synthesize statusItem;
@synthesize menu;
@synthesize menuItems;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:24.0f];
    NSImage *icon = [NSImage imageNamed:@"toolbar_icon.png"];
    [statusItem setImage:icon];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    
    menuItems = [[NSMutableArray alloc] init];
    
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
}

- (void)didSelectDrushMenuItem:(SiteMenuItem *)sender {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryPath = [sender.site objectForKey:@"folder"];
    task.launchPath = @"/Users/itarato/Web/drush/drush";
    task.arguments = @[@"cache-clear", @"all"];
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", output);
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Drush command";
    notification.informativeText = output;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
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
    NSError *error;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:&error];
    
    if (error != nil) {
        NSLog(@"Error when attempted to open file.");
        return;
    }
    
    NSData *configData = [fileHandle readDataToEndOfFile];
    
    NSError *jsonError;
    id json = [NSJSONSerialization JSONObjectWithData:configData options:0 error:&jsonError];
    if (error != nil || ![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error occurred during JSON parsing.");
        return;
    }
    NSArray *sites = [json objectForKey:@"sites"];
    
    for (id item in menuItems) {
        [menu removeItem:item];
    }
    [menuItems removeAllObjects];
    
    int keyCode = 0;
    NSString *keyCodeString;
    for (id site in sites) {
        if (keyCode <= 9) {
            keyCodeString = [NSString stringWithFormat:@"%d", keyCode];
            keyCode++;
        } else {
            keyCodeString = nil;
        }
        
        SiteMenuItem *menuItem = [[SiteMenuItem alloc] initWithTitle:[site objectForKey:@"name"] action:@selector(didSelectDrushMenuItem:) keyEquivalent:keyCodeString];
        menuItem.site = site;
        [menu addItem:menuItem];
        [menuItems addObject:menuItem];

        NSMenu *submenu = [[NSMenu alloc] init];
        NSArray *arguments = [[NSMutableArray alloc] initWithObjects:
                              [[NamedArguments alloc] initWithName:@"Cache clear" andArguments:@"cc", @"all", nil],
                              [[NamedArguments alloc] initWithName:@"Revert all features" andArguments:@"fra", @"-y", nil],
                              [[NamedArguments alloc] initWithName:@"Update database" andArguments:@"updb", @"-y", nil],
                              nil];
        for (NamedArguments* namedArg in arguments) {
            SiteMenuItem *subMenuItem = [[SiteMenuItem alloc] initWithTitle:namedArg.name action:@selector(didSelectDrushMenuItem:) keyEquivalent:@""];
            subMenuItem.arguments = namedArg.arguments;
            [submenu addItem:subMenuItem];
        }
        [menuItem setSubmenu:submenu];
    }
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end

//
//  MenuBuilder.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "MenuBuilder.h"
#import "SiteMenuItem.h"
#import "NamedArguments.h"

@implementation MenuBuilder

@synthesize menuItems;

+ (MenuBuilder *)mainBuilder {
    static MenuBuilder *instance;
    if (instance == nil) {
        instance = [[MenuBuilder alloc] init];
        instance.menuItems = [[NSMutableArray alloc] init];
    }
    return instance;
}

- (void)fromConfigurationFileURL:(NSURL *)url onMenu:(NSMenu *)menu usingAction:(SEL)selector {
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
        keyCodeString = keyCode <= 9 ? [NSString stringWithFormat:@"%d", keyCode++] : @"";
        
        SiteMenuItem *menuItem = [[SiteMenuItem alloc] initWithTitle:[site objectForKey:@"name"]
                                                              action:selector
                                                       keyEquivalent:keyCodeString
                                                                site:site
                                                        andArguments:[NSArray arrayWithObjects:@"cc", @"all", nil]];
        [menu addItem:menuItem];
        [menuItems addObject:menuItem];
        
        NSMenu *submenu = [[NSMenu alloc] init];
        NSMutableArray *arguments = [[NSMutableArray alloc] initWithObjects:
                              [[NamedArguments alloc] initWithName:@"Cache clear" andArguments:@"cc", @"all", nil],
                              [[NamedArguments alloc] initWithName:@"Revert all features" andArguments:@"fra", @"-y", nil],
                              [[NamedArguments alloc] initWithName:@"Update database" andArguments:@"updb", @"-y", nil],
                              nil];
        
        id extra_commands;
        if ((extra_commands = [site objectForKey:@"extra_commands"]) != nil) {
            for (id extra_command in extra_commands) {
                [arguments addObject:[[NamedArguments alloc]
                                      initWithName:[extra_command objectForKey:@"name"]
                                      andArgumentArray:[extra_command objectForKey:@"arguments"]]];
            }
        }
        
        for (NamedArguments* namedArg in arguments) {
            SiteMenuItem *subMenuItem = [[SiteMenuItem alloc] initWithTitle:namedArg.name
                                                                     action:selector
                                                              keyEquivalent:@""
                                                                       site:site
                                                               andArguments:namedArg.arguments];
            [submenu addItem:subMenuItem];
        }
        [menuItem setSubmenu:submenu];
    }
}

@end
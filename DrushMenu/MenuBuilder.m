//
//  MenuBuilder.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "MenuBuilder.h"
#import "SiteMenuItem.h"
#import "AppConfiguration.h"
#import "SiteConfiguration.h"
#import "Command.h"

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

- (void)fromAppConfiguration:(AppConfiguration *)appConfig onMenu:(NSMenu *)menu usingAction:(SEL)selector {
    NSArray *sites = appConfig.sites;
    
    for (id item in menuItems) {
        [menu removeItem:item];
    }
    [menuItems removeAllObjects];
    
    for (SiteConfiguration *site in sites) {
        // Parent menu item.
        SiteMenuItem *menuItem = [[SiteMenuItem alloc] initWithTitle:site.name
                                                              action:nil
                                                       keyEquivalent:@""
                                                                site:site
                                                          andCommand:nil];
        [menu addItem:menuItem];
        [menuItems addObject:menuItem];
        
        // Default commands.
        NSMenu *submenu = [[NSMenu alloc] init];
        
        // Add submenu items.
        for (Command *command in site.commands) {
            SiteMenuItem *subMenuItem = [[SiteMenuItem alloc] initWithTitle:command.title
                                                                     action:selector
                                                              keyEquivalent:@""
                                                                       site:site
                                                                 andCommand:command];
            [submenu addItem:subMenuItem];
        }
        [menuItem setSubmenu:submenu];
    }
}

@end

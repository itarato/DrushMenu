//
//  SiteMenuItem.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SiteMenuItem : NSMenuItem

@property (nonatomic, retain) id site;
@property (nonatomic, retain) NSArray *arguments;

@end

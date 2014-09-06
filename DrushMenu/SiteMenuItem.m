//
//  SiteMenuItem.m
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "SiteMenuItem.h"

@implementation SiteMenuItem

@synthesize site;
@synthesize arguments;

- (id)initWithTitle:(NSString *)aString
             action:(SEL)aSelector
      keyEquivalent:(NSString *)charCode
               site:(id)aSite
       andArguments:(NSArray *)args {
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode]) {
        self.site = aSite;
        self.arguments = args;
    }
    return self;
}

- (NSString *)getPath {
    return [self.site objectForKey:@"folder"];
}

@end

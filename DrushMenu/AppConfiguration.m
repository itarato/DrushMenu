//
//  JSONConfiguration.m
//  DrushMenu
//
//  Created by Peter Arato on 9/7/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import "AppConfiguration.h"
#import "SiteConfiguration.h"

@interface AppConfiguration()

- (void)parse:(NSData *)data;

@end

@implementation AppConfiguration

@synthesize sites;

- (id)initWithData:(NSData *)data {
    if (self = [super init]) {
        [self parse:data];
    }
    return self;
}

- (void)parse:(NSData *)data {
    NSError *json_error;
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&json_error];
    
    if (json_error != nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error occurred during JSON parsing.");
        return;
    }
    
    NSArray *sites_raw = [dictionary objectForKey:@"sites"];
    self.sites = [[NSMutableArray alloc] initWithCapacity:[sites_raw count]];
    
    for (id site in sites_raw) {
        [self.sites addObject:[[SiteConfiguration alloc] initWithDictionary:site]];
    }
}

@end

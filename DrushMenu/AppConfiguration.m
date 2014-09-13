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

- (void)parse;
- (NSString *)getPListPath;

@end

@implementation AppConfiguration

@synthesize sites;
@synthesize drushPath;
@synthesize data;

+ (AppConfiguration *)mainConfig {
    static AppConfiguration *instance;
    if (instance == nil) {
        instance = [[AppConfiguration alloc] init];
    }
    return instance;
}

- (BOOL)loadFromData:(NSData *)theData {
    NSError *json_error;
    self.data = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&json_error];
    
    if (json_error != nil || ![self.data isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error occurred during JSON parsing.");
        return NO;
    }
    
    [self parse];
    return YES;
}

- (void)parse {
    NSArray *sites_raw = [self.data objectForKey:@"sites"];
    self.sites = [[NSMutableArray alloc] initWithCapacity:[sites_raw count]];
    
    for (id site in sites_raw) {
        [self.sites addObject:[[SiteConfiguration alloc] initWithDictionary:site]];
    }
    
    self.drushPath = [self.data objectForKey:@"drush"];
}

- (void)save {
    NSString *error;
    NSString *pListPath = [self getPListPath];
    NSDictionary *pListDict = self.data;
    NSData *pListData = [NSPropertyListSerialization dataFromPropertyList:pListDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if (pListData) {
        [pListData writeToFile:pListPath atomically:YES];
    } else {
        NSLog(@"%@", error);
    }
}

- (NSString *)getPListPath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pListPath = [rootPath stringByAppendingPathComponent:@"DrushMenuAppPropertyList.plist"];
    return pListPath;
}

- (BOOL)loadFromSave {
    NSString *error = nil;
    NSPropertyListFormat format;
    NSString *pListPath = [self getPListPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pListPath]) {
        return NO;
    }
    NSData *pListXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
    NSDictionary *dictionary = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:pListXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];
    if (!dictionary) {
        NSLog(@"%@", error);
        return NO;
    }
    
    self.data = dictionary;
    [self parse];
    
    return YES;
}

- (BOOL)isSavedConfigExist {
    return NO;
}

@end

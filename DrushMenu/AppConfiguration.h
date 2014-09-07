//
//  JSONConfiguration.h
//  DrushMenu
//
//  Created by Peter Arato on 9/7/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfiguration : NSObject

@property (nonatomic, retain) NSMutableArray *sites;
@property (nonatomic, retain) NSString *drushPath;
@property (nonatomic, retain) NSDictionary *data;

+ (AppConfiguration *)mainConfig;

- (BOOL)loadFromData:(NSData *)theData;
- (void)save;
- (BOOL)isSavedConfigExist;
- (BOOL)loadFromSave;

@end

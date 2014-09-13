//
//  SiteConfiguration.h
//  DrushMenu
//
//  Created by Peter Arato on 9/7/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteConfiguration : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *folder;
@property (nonatomic, retain) NSMutableArray *commands;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

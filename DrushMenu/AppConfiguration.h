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

- (id)initWithData:(NSData *)data;

@end

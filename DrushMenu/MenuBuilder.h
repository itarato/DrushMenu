//
//  MenuBuilder.h
//  DrushMenu
//
//  Created by Peter Arato on 9/6/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuBuilder : NSObject

@property (nonatomic, retain) NSMutableArray *menuItems;

+ (MenuBuilder *)mainBuilder;

- (void)fromConfigurationFileURL:(NSURL *)url onMenu:(NSMenu *)menu usingAction:(SEL)selector;

@end

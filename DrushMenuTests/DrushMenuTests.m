//
//  DrushMenuTests.m
//  DrushMenuTests
//
//  Created by Peter Arato on 9/5/14.
//  Copyright (c) 2014 Peter Arato. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppConfiguration.h"
#import "Command.h"
#import "SiteConfiguration.h"

@interface DrushMenuTests : XCTestCase

@property (nonatomic, retain) NSString *configuration;

@end

@implementation DrushMenuTests

- (void)setUp
{
    [super setUp];
    self.configuration = @"\
{\
    \"drush\": \"/foo/bar\",\
    \"sites\": [\
        {\
            \"name\": \"foobar\",\
            \"folder\": \"/web/foo\",\
            \"commands\": [\
                {\
                    \"name\": \"Foo command\",\
                    \"arguments\": [\"arg1\", \"arg2\"],\
                    \"hotkey\": \"85\"\
                }\
            ]\
        }\
    ]\
}";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testConfiguration
{
    NSData *jsonData = [self.configuration dataUsingEncoding:NSUTF8StringEncoding];
    [[AppConfiguration mainConfig] loadFromData:jsonData];
    XCTAssertTrue([[[AppConfiguration mainConfig] drushPath] isEqualToString:@"/foo/bar"], @"Drush path is correct");
    XCTAssertTrue([[[AppConfiguration mainConfig] sites] count] == 1, @"There is one site.");
    
    SiteConfiguration *siteConfig = [[[AppConfiguration mainConfig] sites] objectAtIndex:0];
    XCTAssertTrue([[siteConfig commands] count] == 1, @"There is one command");
    XCTAssertTrue([[siteConfig name] isEqualToString:@"foobar"], @"Site name is correct");
    XCTAssertTrue([[siteConfig folder] isEqualToString:@"/web/foo"], @"Folder is correct");
    
    Command *command = [[siteConfig commands] objectAtIndex:0];
    XCTAssertTrue([[command title] isEqualToString:@"Foo command"], @"Command name is correct");
    XCTAssertTrue([[command arguments] count] == 2, @"There are 2 arguments");
    XCTAssertTrue([[command hotkey] isEqualToString:@"85"], @"Hotkey is set");
}

@end

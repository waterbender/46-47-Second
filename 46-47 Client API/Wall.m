//
//  Wall.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "Wall.h"
#import "ServerManager.h"

@implementation Wall

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary
{
    self = [super initWithServerResponse:dictionary];
    if (self) {
        
        NSLog(@"%@", dictionary);
        
        self.item_id = [[dictionary objectForKey: @"id"] stringValue];
        self.text = [dictionary objectForKey:@"text"];
        self.likes = [[[dictionary objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        NSNumber *dateNum = [dictionary objectForKey:@"date"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
        self.idForPost = [[dictionary objectForKey:@"owner_id"] stringValue];

        
        [[ServerManager sharedManager] getUserFromID: [[dictionary objectForKey:@"from_id"] stringValue] userSuccess:^(User *user) {
            self.user = user;
            
        } andFailture:nil];
    }
    return self;
}

@end

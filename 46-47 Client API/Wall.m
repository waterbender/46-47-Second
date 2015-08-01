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
        
        
        
        NSNumber *dateNum = [dictionary objectForKey:@"date"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
        self.text = [dictionary objectForKey:@"text"];
        self.likes = [[[dictionary objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        

        [[ServerManager sharedManager] getUserFromID:[dictionary objectForKey:@"from_id"] userSuccess:^(User *user) {
            self.user = user;
            
        } andFailture:nil];
    }
    return self;
}

@end

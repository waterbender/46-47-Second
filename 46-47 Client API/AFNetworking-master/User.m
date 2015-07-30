//
//  User.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "User.h"

@implementation User


- (instancetype)initWithServerResponse : (NSDictionary*) dictionary {
    self = [super initWithServerResponse:dictionary];
    if (self) {
        
        self.id = [[dictionary objectForKey:@"id"] stringValue];
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        self.photo_50 = [dictionary objectForKey:@"photo_50"];
    }
    return self;
}

@end

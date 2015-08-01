//
//  Group.m
//  46-47 Client API
//
//  Created by  ZHEKA on 31.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "Group.h"

@implementation Group

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary {
    self = [super initWithServerResponse:dictionary];
    if (self) {
        
        NSLog(@"%@", dictionary);
        
        self.id = [[dictionary objectForKey:@"id"] stringValue];
        self.name = [dictionary objectForKey:@"name"];
        self.photo_50 = [dictionary objectForKey:@"photo_50"];
        self.photo_100 = [dictionary objectForKey:@"photo_100"];
        self.photo_200 = [dictionary objectForKey:@"photo_200"];
    }
    return self;
}


@end

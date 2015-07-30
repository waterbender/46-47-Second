//
//  Wall.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "Wall.h"

@implementation Wall

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary
{
    self = [super initWithServerResponse:dictionary];
    if (self) {
        
        self.text = [dictionary objectForKey:@"text"];
        
    }
    return self;
}

@end

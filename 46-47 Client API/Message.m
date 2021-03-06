//
//  Message.m
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary {
    
    self = [super init];
    if (self) {
        
        
        self.messageID = [[dictionary objectForKey:@"id"] stringValue];
        self.dateMessage = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"date"] doubleValue]];
        self.userID = [[dictionary objectForKey:@"user_id"] stringValue];
        self.readState = [[dictionary objectForKey:@"read_state"] boolValue];
        self.title = [dictionary objectForKey:@"title"];
        self.body = [dictionary objectForKey:@"body"];
        
    }
    return self;
}

@end

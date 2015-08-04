//
//  AboutUser.m
//  46-47 Client API
//
//  Created by  ZHEKA on 01.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "AboutUser.h"

@implementation AboutUser

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary {
    self = [super initWithServerResponse:dictionary];
    if (self) {
        
        NSLog(@"%@", dictionary);
        
        self.id = [[dictionary objectForKey:@"id"] stringValue];
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        self.photo_50 = [dictionary objectForKey:@"photo_50"];
        self.photo_100 = [dictionary objectForKey:@"photo_100"];
        self.photo_max = [dictionary objectForKey:@"photo_max"];
        self.status = [dictionary objectForKey:@"status"];
        self.online = [[dictionary objectForKey:@"online"] boolValue];
        self.educatioForm = [dictionary objectForKey:@"education_form"];
        self.facultyName = [dictionary objectForKey:@"faculty_name"];
        self.universityName = [dictionary objectForKey:@"university_name"];
        
        
    }
    
    
    return self;
}

@end

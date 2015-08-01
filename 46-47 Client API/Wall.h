//
//  Wall.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"
#import "User.h"

@interface Wall : ServerObject

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger likes;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDate *date;

@end

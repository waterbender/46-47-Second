//
//  CommentObject.h
//  46-47 Client API
//
//  Created by  ZHEKA on 09.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"
#import "User.h"

@interface CommentObject : ServerObject

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger likes;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *item_id;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *groupID;

@end

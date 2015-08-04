//
//  Message.h
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"

@interface Message : ServerObject

@property (strong, nonatomic) NSString *messageID;
@property (strong, nonatomic) NSDate *dateMessage;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (assign, nonatomic) BOOL readState;



@end

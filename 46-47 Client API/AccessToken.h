//
//  AccessToken.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"

@interface AccessToken : ServerObject

@property (strong, nonatomic) NSString *token, *id;
@property (strong, nonatomic) NSDate *expires;

- (instancetype)initWithServerResponse : (NSDictionary*) dictionary;

@end

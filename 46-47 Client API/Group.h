//
//  Group.h
//  46-47 Client API
//
//  Created by  ZHEKA on 31.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"

@interface Group : ServerObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *photo_50;
@property (strong, nonatomic) NSString *photo_100, *photo_200;

@end

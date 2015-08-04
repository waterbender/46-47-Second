//
//  AboutUser.h
//  46-47 Client API
//
//  Created by  ZHEKA on 01.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"

@interface AboutUser : ServerObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *photo_50;
@property (strong, nonatomic) NSString *photo_100;
@property (strong, nonatomic) NSString *photo_max;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *educatioForm;
@property (strong, nonatomic) NSString *facultyName;
@property (strong, nonatomic) NSString *universityName;

@property (assign, nonatomic) BOOL online;


@end

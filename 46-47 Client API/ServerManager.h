//
//  ServerManager.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "User.h"


@interface ServerManager : NSObject

+ (instancetype) sharedManager;

- (void) getWallFromID : (NSString*) ownerID
            withOffset : (NSInteger) offset
               andCount: (NSInteger) count
            wallSuccess: (void(^)(NSMutableArray *array)) success
            andFailture: (void(^)(NSError *error)) failture;

- (void) authorizeUserWithSuccess: (void(^)(User *user)) success
                      andFailture: (void(^)(NSError *error)) failture;


@end

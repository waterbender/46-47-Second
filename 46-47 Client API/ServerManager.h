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
#import "Group.h"

@interface ServerManager : NSObject

+ (instancetype) sharedManager;

- (void) getWallFromID : (NSString*) ownerID
            withOffset : (NSInteger) offset
               andCount: (NSInteger) count
            wallSuccess: (void(^)(NSMutableArray *array)) success
            andFailture: (void(^)(NSError *error)) failture;

- (void) authorizeUserWithSuccess: (void(^)(User *user)) success
                      andFailture: (void(^)(NSError *error)) failture;

- (void) postNewsOnId : (NSString*) id
message: (NSString*) message
witthSuccess: (void(^)(NSString *str)) success
andFailture: (void(^)(NSError *error)) failture;

- (void) getUserFromID : (NSString*) ownerID
            userSuccess: (void(^)(User *user)) success
            andFailture: (void(^)(NSError *error)) failture;

- (void) getGroupFromID : (NSString*) ownerID
             userSuccess: (void(^)(Group *group)) success
             andFailture: (void(^)(NSError *error)) failture;


@property (strong, nonatomic) User *userForToken;

@end

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

extern NSString* const ServerManagerUserForTokenDidChangeNotification;
extern NSString* const ServerManagerUserForTokenKey;

@class AboutUser;
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

- (void) getAboutUserFromID : (NSString*) ownerID
                 userSuccess: (void(^)(AboutUser *about)) success
                 andFailture: (void(^)(NSError *error)) failture;

- (void) getFriendsFromID : (NSString*) ownerID
              withOffset: (NSInteger) offset
                andCount: (NSInteger) count
             userSuccess: (void(^)(NSMutableArray *usersArray)) success
             andFailture: (void(^)(NSError *error)) failture;

- (void) getFollowersFromID : (NSString*) ownerID
                  withOffset: (NSInteger) offset
                    andCount: (NSInteger) count
                 userSuccess: (void(^)(NSMutableArray *usersArray)) success
                 andFailture: (void(^)(NSError *error)) failture;

- (void) getSubscriptionsFromID : (NSString*) ownerID
                      withOffset: (NSInteger) offset
                        andCount: (NSInteger) count
                     userSuccess: (void(^)(NSMutableArray *usersArray)) success
                     andFailture: (void(^)(NSError *error)) failture;

- (void) getDialogsWithOffset: (NSInteger) offset
                     andCount: (NSInteger) count
               previewLength : (NSInteger) length
                  userSuccess: (void(^)(NSMutableArray *dialogsArray)) success
                  andFailture: (void(^)(NSError *error)) failture;


- (void) getMessageWithUserId: (NSString*) userID
               thatHaveOffset: (NSInteger) offset
                     andCount: (NSInteger) count
                  userSuccess: (void(^)(NSMutableArray *messagesArray)) success
                  andFailture: (void(^)(NSError *error)) failture;

- (void) postText: (NSString*) text
           toUser: (NSString*) userID
      userSuccess: (void(^)(User *user)) success
      andFailture: (void(^)(NSError *error)) failture;

- (void) postLike: (NSString*) type
           toUser: (NSString*) owner_id
           itemID: (NSString*) item_id
      userSuccess: (void(^)(NSInteger count)) success
      andFailture: (void(^)(NSError *error)) failture;

- (void) postDeleteLike: (NSString*) type
                toOwner: (NSString*) owner_id
                 itemID: (NSString*) item_id
            userSuccess: (void(^)(NSInteger count)) success
            andFailture: (void(^)(NSError *error)) failture;

- (void) getCommentsWithOwnerID: (NSString*) ownerID
                        postID: (NSString*) postID
                        offset: (NSInteger) offset
                      andCount: (NSInteger) count
                   userSuccess: (void(^)(NSMutableArray *commentsArray)) success
                   andFailture: (void(^)(NSError *error)) failture;

@property (strong, nonatomic) User *userForToken;

@end

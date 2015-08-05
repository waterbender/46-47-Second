//
//  ServerManager.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "ServerManager.h"
#import "Wall.h"
#import "AccessToken.h"
#import "AuthorizationViewController.h"
#import "AboutUser.h"
#import "Message.h"
#import "OwnMessage.h"

NSString* const ServerManagerUserForTokenDidChangeNotification = @"ServerManageruserForTokenDidChangeNotification";

NSString* const ServerManagerUserForTokenKey = @"ServerManagerUserForTokenKey";

@interface ServerManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) AccessToken *token;

@end

@implementation ServerManager

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL: url];
    }
    return self;
}

- (void) setUserForToken:(User *)userForToken {
    
    _userForToken = userForToken;
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:userForToken forKey:ServerManagerUserForTokenKey];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ServerManagerUserForTokenDidChangeNotification
     object:nil
     userInfo:dictionary];
    
}

+ (instancetype) sharedManager {
    
    static ServerManager *serverManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverManager = [[ServerManager alloc] init];
    });
    
    
    return serverManager;
}


//58860049

- (void) getWallFromID : (NSString*) ownerID
            withOffset : (NSInteger) offset
               andCount: (NSInteger) count
            wallSuccess: (void(^)(NSMutableArray *array)) success
            andFailture: (void(^)(NSError *error)) failture {
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        ownerID, @"owner_id",
                                        @(offset), @"offset",
                                        @(count), @"count",
                                        @"all", @"filter",
                                        @"5.35", @"v"
                                        , nil];
    
    [self.manager GET:@"wall.get" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        NSLog(@"%@", dictionary);
        
        
        NSMutableArray *resultArray = [NSMutableArray array];
        
        NSArray *dictArray = [[dictionary objectForKey:@"response"] objectForKey:@"items"];
        
        for (NSDictionary *postDict in dictArray) {
         
            Wall *wall = [[Wall alloc] initWithServerResponse:postDict];
            
            [resultArray addObject:wall];
        }
        
        if (success) {
            success(resultArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {

        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
    
        if (failture) {
            failture(error);
        }
    }];
                
}


- (void) getUserFromID : (NSString*) ownerID
            userSuccess: (void(^)(User *user)) success
            andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"user_ids",
                            @"photo_50, photo_100", @"fields",
                            @"5.35", @"v"
                            , nil];
    
    [self.manager GET:@"users.get" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSArray *dictArray = [dictionary objectForKey:@"response"];

        User *user = [[User alloc] initWithServerResponse:[dictArray firstObject]];
        
        if (success) {
            success(user);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
}



- (void) authorizeUserWithSuccess: (void(^)(User *user)) success
andFailture: (void(^)(NSError *error)) failture {
    
    AuthorizationViewController *vc = [[AuthorizationViewController alloc] initWithBlock:^(AccessToken *token) {
       
        self.token = token;
        
        [self getUserFromID:token.id userSuccess:^(User *user) {
            
            self.userForToken = user;
            success(user);

        } andFailture:^(NSError *error) {
            NSLog(@"Fail USER");
        }];
    }];
    
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    UIViewController *mainCtrl = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
                                   
    [mainCtrl presentViewController:navC animated:YES completion:nil];
    
}

- (void) postNewsOnId : (NSString*) ourID
            message: (NSString*) message
        witthSuccess: (void(^)(NSString *str)) success
        andFailture: (void(^)(NSError *error)) failture {
    
    
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    ourID, @"owner_id",
                                    message, @"message",
                                    self.token.token, @"access_token",
                                    @"5.35", @"v",
                                    nil];
            
            
            [self.manager POST:@"wall.post" parameters:params success:^(AFHTTPRequestOperation * operation, NSDictionary *dictionary) {
                
                NSLog(@"%@", dictionary);
                
                
                
                
                
            } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                
                NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
                
                if (failture) {
                    failture(error);
                }
            }];
}




- (void) getGroupFromID : (NSString*) ownerID
            userSuccess: (void(^)(Group *group)) success
            andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"group_ids",
                            @"description", @"fields",
                            @"5.35", @"v"
                            , nil];
    
    [self.manager GET:@"groups.getById" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSArray *dictArray = [dictionary objectForKey:@"response"];
        
        Group *group = [[Group alloc] initWithServerResponse:[dictArray firstObject]];
        
        if (success) {
            success(group);
        }
        
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
}




- (void) getAboutUserFromID : (NSString*) ownerID
            userSuccess: (void(^)(AboutUser *about)) success
            andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"user_ids",
                            @"photo_50, photo_100, photo_max, online, education, status,", @"fields",
                            @"5.35", @"v",
                            self.token.token, @"access_token"
                            , nil];
    
    [self.manager GET:@"users.get" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSArray *dictArray = [dictionary objectForKey:@"response"];
        
        AboutUser *about = [[AboutUser alloc] initWithServerResponse:[dictArray firstObject]];
        
        if (success) {
            success(about);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
}


- (void) getFriendsFromID : (NSString*) ownerID
                withOffset: (NSInteger) offset
                  andCount: (NSInteger) count
               userSuccess: (void(^)(NSMutableArray *usersArray)) success
               andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"user_id",
                            @"hints", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"online, photo_100", @"fields",
                            @"nom", @"name_case",
                            self.token.token, @"access_token",
                            @"5.35", @"v"
                            , nil];
    
    [self.manager GET:@"friends.get" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSMutableArray *endedArray = [NSMutableArray array];
        NSDictionary *dictArray = [dictionary objectForKey:@"response"];
        NSArray *items = [dictArray objectForKey:@"items"];
        
        for (NSDictionary *dict in items) {
            
            User *user = [[User alloc] initWithServerResponse: dict];
            [endedArray addObject:user];
        }
        
        if (success) {
            success(endedArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
    
}


- (void) getFollowersFromID : (NSString*) ownerID
                   withOffset: (NSInteger) offset
                     andCount: (NSInteger) count
                  userSuccess: (void(^)(NSMutableArray *usersArray)) success
                  andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"user_id",
                            @"hints", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"online, photo_100", @"fields",
                            @"nom", @"name_case",
                            self.token.token, @"access_token",
                            @"5.35", @"v"
                            , nil];
    
    [self.manager GET:@"users.getFollowers" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSMutableArray *endedArray = [NSMutableArray array];
        NSDictionary *dictArray = [dictionary objectForKey:@"response"];
        NSArray *items = [dictArray objectForKey:@"items"];
        
        for (NSDictionary *dict in items) {
            
            User *user = [[User alloc] initWithServerResponse: dict];
            [endedArray addObject:user];
        }
        
        if (success) {
            success(endedArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
    
}


- (void) getSubscriptionsFromID : (NSString*) ownerID
                      withOffset: (NSInteger) offset
                        andCount: (NSInteger) count
                     userSuccess: (void(^)(NSMutableArray *usersArray)) success
                     andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"user_id",
                            @(1), @"extended",
                            @(offset), @"offset",
                            @(count), @"count",
                            @"online, photo_100", @"fields",
                            self.token.token, @"access_token",
                            @"5.35", @"v"
                            , nil];
    
    [self.manager GET:@"users.getSubscriptions" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSMutableArray *endedArray = [NSMutableArray array];
        NSDictionary *dictArray = [dictionary objectForKey:@"response"];
        NSArray *items = [dictArray objectForKey:@"items"];
        
        for (NSDictionary *dict in items) {
            
            User *user = [[User alloc] initWithServerResponse: dict];
            [endedArray addObject:user];
        }
        
        if (success) {
            success(endedArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
    
}


- (void) getDialogsWithOffset: (NSInteger) offset
                        andCount: (NSInteger) count
                    previewLength : (NSInteger) length
                     userSuccess: (void(^)(NSMutableArray *dialogsArray)) success
                     andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(offset), @"offset",
                            @(count), @"count",
                            @"5.35", @"v",
                            self.token.token, @"access_token",
                            nil];
    
    [self.manager GET:@"messages.getDialogs" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSMutableArray *endedArray = [NSMutableArray array];
        NSDictionary *dictArray = [dictionary objectForKey:@"response"];
        NSArray *items = [dictArray objectForKey:@"items"];
        
        for (NSDictionary *dict in items) {
            
            
            NSDictionary *finalDict = [dict objectForKey:@"message"];
            
            Message *message = [[Message alloc] initWithServerResponse:finalDict];
            [endedArray addObject:message];
        }
        
        if (success) {
            success(endedArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
    
}


- (void) getMessageWithUserId: (NSString*) userID
               thatHaveOffset: (NSInteger) offset
                     andCount: (NSInteger) count
                  userSuccess: (void(^)(NSMutableArray *messagesArray)) success
                  andFailture: (void(^)(NSError *error)) failture {
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(offset), @"offset",
                            @(count), @"count",
                            userID, @"user_id",
                            @"5.35", @"v",
                            self.token.token, @"access_token",
                            nil];
    
    [self.manager GET:@"messages.getHistory" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        
        NSLog(@"%@", dictionary);
        
        NSMutableArray *endedArray = [NSMutableArray array];
        NSDictionary *dictArray = [dictionary objectForKey:@"response"];

        NSArray *items = [dictArray objectForKey:@"items"];
        
        for (NSDictionary *dict in items) {
            
            OwnMessage *message = [[OwnMessage alloc] initWithServerResponse:dict];
            
            [endedArray insertObject:message atIndex:0];
        }
        
        if (success) {
            success(endedArray);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
}


- (void) postText: (NSString*) text
           toUser: (NSString*) userID
      userSuccess: (void(^)(User *user)) success
      andFailture: (void(^)(NSError *error)) failture {
    
 
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"user_id",
                            text, @"message",
                            @"5.35", @"v",
                            self.token.token, @"access_token",
                            nil];
    
    [self.manager POST:@"messages.send" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        if (success) {
            success(self.userForToken);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
    
}

- (void) postLike: (NSString*) type
           toUser: (NSString*) owner_id
           itemID: (NSString*) item_id
      userSuccess: (void(^)(NSInteger count)) success
      andFailture: (void(^)(NSError *error)) failture {
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            type, @"type",
                            owner_id, @"owner_id",
                            item_id, @"item_id",
                            self.token.token, @"access_token",
                            @"5.35", @"v",
                            
                            nil];

    
    [self.manager POST:@"likes.add" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        NSInteger likes = [[[dictionary objectForKey:@"response"] objectForKey:@"likes"] integerValue];
        
        if (success) {
            success(likes);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
}


- (void) postDeleteLike: (NSString*) type
                 toOwner: (NSString*) owner_id
                 itemID: (NSString*) item_id
            userSuccess: (void(^)(NSInteger count)) success
            andFailture: (void(^)(NSError *error)) failture {
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            type, @"type",
                            owner_id, @"owner_id",
                            item_id, @"item_id",
                            self.token.token, @"access_token",
                            @"5.35", @"v",
                            
                            nil];
    
    
    [self.manager POST:@"likes.delete" parameters:params success:^(AFHTTPRequestOperation * operation, id dictionary) {
        
        NSInteger likes = [[[dictionary objectForKey:@"response"] objectForKey:@"likes"] integerValue];
        
        if (success) {
            success(likes);
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@ %ld", [error localizedDescription], [operation.responseObject statusCode]);
        
        if (failture) {
            failture(error);
        }
    }];
}

@end

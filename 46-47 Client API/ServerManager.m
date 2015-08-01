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


@end

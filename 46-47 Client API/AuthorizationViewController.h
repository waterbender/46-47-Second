//
//  AuthorizationViewController.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessToken.h"

typedef void(^BlockToken)(AccessToken *token);

@interface AuthorizationViewController : UIViewController

- (instancetype)initWithBlock : (BlockToken) tokenBlock;

@end

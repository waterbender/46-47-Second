//
//  MessageWithUserController.h
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageWithUserController : UITableViewController

@property (strong, nonatomic) NSString *userID;
- (IBAction)sendText:(UIButton *)sender;

@end

//
//  UsersFromPage.h
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ChoosenPeopleFollowers = 0,
    ChoosenPeopleFriends = 1,
    ChoosenPeopleSubscribes = 2,
    
} ChoosenPeople;

@interface UsersFromPage : UITableViewController

@property (assign, nonatomic) ChoosenPeople choosen;

@end

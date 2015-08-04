//
//  UsersFromPage.m
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "UsersFromPage.h"
#import "HeaderCell.h"
#import "User.h"
#import "ServerManager.h"
#import "UIView+renderingPicture.h"
#import "UIImageView+AFNetworking.h"



@interface UsersFromPage ()

@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) User *loadedUser;

@end

@implementation UsersFromPage

-(void)viewDidLoad {
    
    self.usersArray = [[NSMutableArray alloc] init];
    self.loadedUser = [ServerManager sharedManager].userForToken;
    
    [self generateUsers];
}

- (void) generateUsers {
    
    if (self.choosen == ChoosenPeopleFriends) {
        
        self.navigationItem.title = @"Friends:";
        [[ServerManager sharedManager] getFriendsFromID:self.loadedUser.id withOffset:[[self usersArray] count] andCount:20 userSuccess:^(NSMutableArray *usersArray) {
            
            [self.usersArray addObjectsFromArray:usersArray];
            [self.tableView reloadData];
            
        } andFailture:^(NSError *error) {
            
        }];
    } else if (self.choosen == ChoosenPeopleFollowers) {
 
        self.navigationItem.title = @"Followers:";
        [[ServerManager sharedManager] getFollowersFromID:self.loadedUser.id withOffset:[[self usersArray] count] andCount:20 userSuccess:^(NSMutableArray *usersArray) {
            
            [self.usersArray addObjectsFromArray:usersArray];
            [self.tableView reloadData];
            
            
            
            
        } andFailture:^(NSError *error) {
            
        }];
    } else if (self.choosen == ChoosenPeopleSubscribes) {
        
        self.navigationItem.title = @"Subscribes:";              
        [[ServerManager sharedManager] getSubscriptionsFromID:self.loadedUser.id withOffset:[[self usersArray] count] andCount:20 userSuccess:^(NSMutableArray *usersArray) {
            
            [self.usersArray addObjectsFromArray:usersArray];
            [self.tableView reloadData];
        } andFailture:^(NSError *error) {
            
        }];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.usersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *keyString = @"ForUserIdentifierKeyCell";
    
    HeaderCell *userCell = (HeaderCell*)[self.tableView dequeueReusableCellWithIdentifier:keyString];
    
    if (!userCell) {
        
        userCell = [[HeaderCell alloc] init];
    }
    
    User *user = [self.usersArray objectAtIndex:indexPath.row];
    
    userCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    NSURL *url = [NSURL URLWithString:user.photo_100];
    [userCell.photo setImageWithURL: url];
    [userCell.photo renderingWithRadius:20];
    
    
    return userCell;
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72.f;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [self.usersArray count] - 18) {
        
        [self generateUsers];
    }
}

@end

//
//  MessagesDialogController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "MessagesDialogController.h"
#import "HeaderCell.h"
#import "User.h"
#import "ServerManager.h"
#import "UIView+renderingPicture.h"
#import "UIImageView+AFNetworking.h"
#import "Message.h"
#import "MessageWithUserController.h"

@interface MessagesDialogController ()

@property (strong, nonatomic) NSMutableArray *dialogsArray;
@property (strong, nonatomic) User *loadedUser;

@end

@implementation MessagesDialogController


-(void)viewDidLoad {
    self.dialogsArray = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    self.navigationItem.title = @"Messages:";
    self.loadedUser = [ServerManager sharedManager].userForToken;
    
    [self generateMessages];
}

- (void) refresh : (UIRefreshControl*) refreshControl {
    
    [[ServerManager sharedManager] getDialogsWithOffset:0 andCount:[self.dialogsArray count] previewLength:20 userSuccess:^(NSMutableArray *dialogsArray) {
        
        self.dialogsArray = [NSMutableArray array];
        [self.dialogsArray addObjectsFromArray:dialogsArray];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
}

- (void) generateMessages {
    
    [[ServerManager sharedManager] getDialogsWithOffset:[self.dialogsArray count]andCount:20 previewLength:20 userSuccess:^(NSMutableArray *dialogsArray) {
        
        [self.dialogsArray addObjectsFromArray:dialogsArray];
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dialogsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *keyString = @"ForUserIdentifierKeyCell";
    static NSString *selectedKeyString = @"ForUserIdentifierKeyCellSelected";
    
    Message *message = [self.dialogsArray objectAtIndex:indexPath.row];
    
    HeaderCell *userCell;
    if (!message.readState) {
        
        userCell = (HeaderCell*)[self.tableView dequeueReusableCellWithIdentifier:selectedKeyString
                                 ];
    } else {
        
        userCell = (HeaderCell*)[self.tableView dequeueReusableCellWithIdentifier:keyString];
 }
    
    if (!userCell) {
        
        userCell = [[HeaderCell alloc] init];
    }
    
    
    if (!message.readState) {
        
        UIColor *color = [UIColor colorWithRed:0.4 green:0.1 blue:0.6 alpha:0.3];
        userCell.backgroundColor = color;
    }
    
    userCell.nameLabel.text = message.body;
    userCell.nameAndLastName.text = @"Hello";
    
    [[ServerManager sharedManager] getUserFromID:message.userID userSuccess:^(User *user) {

        NSURL *url = [NSURL URLWithString:user.photo_100];
        userCell.nameAndLastName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        [userCell.photo setImageWithURL: url];
        [userCell.photo renderingWithRadius:20];
        
    } andFailture:^(NSError *error) {
        
    }];
    
    return userCell;
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72.f;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Message *message = [self.dialogsArray objectAtIndex:indexPath.row];
    MessageWithUserController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"MessageWithUserController"];
    vc.userID = message.userID;

    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [self.dialogsArray count] - 18) {
        
        [self generateMessages];
    }
}

@end

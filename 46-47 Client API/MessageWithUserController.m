//
//  MessageWithUserController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "MessageWithUserController.h"
#import "MessageCell.h"
#import "OwnMessage.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+renderingPicture.h"
#import "SendTextCell.h"

@interface MessageWithUserController ()

@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *friend;
@property (assign, nonatomic) BOOL firstStart, choosenMessage;
@property (assign, nonatomic) NSInteger previousCount;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation MessageWithUserController

-(void) viewDidLoad {
    
    self.messagesArray = [NSMutableArray array];
    
    self.firstStart = YES;
    self.choosenMessage = NO;
    
    [[ServerManager sharedManager] getUserFromID:self.userID userSuccess:^(User *user) {
        
        
        self.friend = user;
        self.navigationItem.title = user.firstName;
        self.user = [ServerManager sharedManager].userForToken;
        [self generateMessages];
        
        [self.tableView reloadData];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
        
    } andFailture:^(NSError *error) {
        
    }];
}

- (void) refreshMessages {

    @synchronized (nil) {
        
    self.previousCount = [self.messagesArray count];
    
    [[ServerManager sharedManager] getMessageWithUserId:self.friend.id thatHaveOffset:0 andCount:[self.messagesArray count] userSuccess:^(NSMutableArray *messagesArray) {
        
        self.messagesArray = [NSMutableArray array];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.previousCount)];
        [self.messagesArray insertObjects:messagesArray atIndexes:indexSet];

        
        NSMutableArray *indexesArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i <= [self.messagesArray count]; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexesArray addObject:indexpath];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.tableView reloadRowsAtIndexPaths:indexesArray withRowAnimation:UITableViewRowAnimationNone];
        });


    } andFailture:^(NSError *error) {
        
        
    }];
    }
    
}


- (void) generateMessages {
    
    self.previousCount = [self.messagesArray count];
    
    [[ServerManager sharedManager] getMessageWithUserId:self.friend.id thatHaveOffset:[self.messagesArray count] andCount:10 userSuccess:^(NSMutableArray *messagesArray) {
        
        if ([messagesArray count] > 0) {
            
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
        [self.messagesArray insertObjects:messagesArray atIndexes:indexSet];

        [self.tableView reloadData];

        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.messagesArray count] - self.previousCount + 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    } andFailture:^(NSError *error) {
       
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.messagesArray || [self.messagesArray count] == 0) {
        return 2;
    } else {
        return [self.messagesArray count] + 2; }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *keyForUser = @"MessageCellKeyUser";
    static NSString *keyForFriend = @"MessageCellKey";
    static NSString *addMessages = @"AddMesages";
    static NSString *sendMessage = @"SendPostText";
    static NSString *sendMessageShowing = @"SendPost";
    
    if (indexPath.row == 0) {
    
        UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: addMessages];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Generate messages";
        cell.backgroundColor = [UIColor grayColor];
        
        return cell;
        
    } else if (indexPath.row == [self.messagesArray count] + 1) {
        
       
        
        if (!self.choosenMessage) {
        
            SendTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:sendMessage];
            
            return cell;
        } else {
            
            SendTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:sendMessageShowing];
            
            return cell;
        }
    } else {
    

    indexPath =  [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    OwnMessage *message = [self.messagesArray objectAtIndex:indexPath.row];
    
    MessageCell *cell;
    
    if ([message.messageID isEqualToString:self.user.id]) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:keyForUser];
        cell.photoView.image = nil;
        cell.messageLabel.text = message.body;
        cell.nameLabel.text = self.user.firstName;
        cell.messageLabel.text = message.body;

        NSURL *url = [NSURL URLWithString:self.user.photo_50];
        [cell.photoView setImageWithURL: url];
        [cell.photoView renderingWithRadius:20];

        return cell;
        
    } else {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:keyForFriend];
        
        cell.photoView.image = nil;
        cell.messageLabel.text = message.body;
        cell.nameLabel.text = self.friend.firstName;
        cell.messageLabel.text = message.body;
        
        NSURL *url = [NSURL URLWithString:self.friend.photo_50];
        [cell.photoView setImageWithURL: url];
        [cell.photoView renderingWithRadius:20];
        
        return cell;
    }
    
        return [[UITableViewCell alloc] init];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || ((indexPath.row == [self.messagesArray count] + 1) && !self.choosenMessage)) {
        
        return 50.f;
        
    } else if (indexPath.row == [self.messagesArray count] + 1) {
        
        return 90.f;
    }
    
    OwnMessage *message = [self.messagesArray objectAtIndex:indexPath.row -1 ];
    if (message.body) {
        
        return [MessageCell heightForCellWithText:message.body] + 100;
    } else {
        
        return 50.f;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self generateMessages];
        return;
    }
    
    if (indexPath.row == [self.messagesArray count] + 1) {
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.messagesArray count]+1 inSection:0];
        self.choosenMessage = !self.choosenMessage;
        
        [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
        
    } else {
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.messagesArray count]+1 inSection:0];
        self.choosenMessage = NO;
        [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}


- (IBAction)sendText:(UIButton *)sender {

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messagesArray count] + 1 inSection:0];
    SendTextCell *cell = (SendTextCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [[ServerManager sharedManager] postText:cell.textView.text toUser:self.friend.id userSuccess:^(User *user) {
        cell.textView.text = @"";
        
        [self refreshMessages];

    } andFailture:nil];
    
    
}
@end

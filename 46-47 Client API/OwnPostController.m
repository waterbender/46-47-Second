//
//  OwnPostController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 05.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "OwnPostController.h"
#import "UIView+renderingPicture.h"
#import "UIImageView+AFNetworking.h"
#import "ServerManager.h"
#import "CommentObject.h"
#import "SendTextCell.h"

@interface OwnPostController ()

@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (assign, nonatomic) BOOL messegeCellHide;
- (IBAction)sendCommentAction:(UIButton *)sender;

@end


@implementation OwnPostController


- (void) viewDidLoad {
    
    self.commentsArray = [NSMutableArray array];
    self.messegeCellHide = YES;
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self generateComments];
}


- (void) refreshComments {
    
    NSInteger count = [self.commentsArray count];
    self.commentsArray = [NSMutableArray array];
    
    [[ServerManager sharedManager] getCommentsWithOwnerID:self.mainNew.idForPost postID:self.mainNew.item_id offset:0 andCount:count userSuccess:^(NSMutableArray *commentsArray) {
        
        [self.commentsArray addObjectsFromArray:commentsArray];
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
}

- (void) generateComments {
    
    [[ServerManager sharedManager] getCommentsWithOwnerID:self.mainNew.idForPost postID:self.mainNew.item_id offset:[self.commentsArray count] andCount:10 userSuccess:^(NSMutableArray *commentsArray) {
        
        [self.commentsArray addObjectsFromArray:commentsArray];
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *postCellKey = @"TextPostCellKey";
    static NSString *cellForComment = @"CommentText";
    static NSString *sendHide = @"SendPostText";
    static NSString *sendShown = @"SendPost";
    
    
    if (indexPath.row == 0) {
        
        SendTextCell *cell;
        
        if (self.messegeCellHide) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:sendHide];
        } else {
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:sendShown];
        }
        
        
        return cell;
        
    } else if (indexPath.row == 1) {
       
        PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:postCellKey];
        
        cell.navConroller = self.navigationController;
        cell.postFromWall = self.mainNew;
        cell.postText.text = self.mainNew.text;
        cell.likeLabel.text = [@(self.mainNew.likes) stringValue];
        cell.userId = self.mainNew.user.id;
        
        if (indexPath.row == 1) {
            if (self.mainNew.user.firstName) {
                            cell.nameAndLastName.text = [NSString stringWithFormat:@"%@ %@", self.mainNew.user.firstName, self.mainNew.user.lastName];
            }
        }
        

        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"ss dd/MM/YYYY"];
        cell.dateOfThePost.text = [formater stringFromDate:self.mainNew.date];
        
        NSURL *url = [NSURL URLWithString: self.mainNew.user.photo_100];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak PostCellTableView *weakCell = cell;
        weakCell.photo.image = nil;
        weakCell.photosVideos = nil;
        
        [weakCell.photo setImageWithURLRequest:request placeholderImage:nil success:^void(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
            
            weakCell.photo.image = image;
            
            [weakCell.photo renderingWithRadius:20];
            
            [weakCell layoutSubviews];
            
        } failure:^void(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
            
        }];
        
        return cell;

    } else {
        
        
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section];
        
        PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:cellForComment];
        
        CommentObject *comment = [self.commentsArray objectAtIndex:indexPath.row];
        comment.groupID = self.mainNew.idForPost;
        
        cell.navConroller = self.navigationController;

        cell.postText.text = comment.text;
        cell.likeLabel.text = [@(comment.likes) stringValue];
        cell.userId = self.mainNew.user.id;
        cell.comment = comment;
        
        cell.nameAndLastName.text = [NSString stringWithFormat:@"%@ %@", comment.user.firstName, comment.user.lastName];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"ss dd/MM/YYYY"];
        cell.dateOfThePost.text = [formater stringFromDate:comment.date];
        
        NSURL *url = [NSURL URLWithString: comment.user.photo_100];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak PostCellTableView *weakCell = cell;
        
        weakCell.photo.image = nil;
        weakCell.photosVideos = nil;
        [weakCell.photo renderingWithRadius:20];
        
        [cell.photo setImageWithURLRequest:request placeholderImage:nil success:^void(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
            

            weakCell.photo.image = image;
            [cell layoutSubviews];
            
            
        } failure:^void(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
            
            
        }];
        
        
        return cell;
    }
    
    return nil;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2 + [self.commentsArray count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && self.messegeCellHide) {
        
        return 50.f;
        
    } else if (indexPath.row == 0 && !self.messegeCellHide) {
        
        return 100;
    } else if (indexPath.row == 1) {
        
        return [PostCellTableView heightForCellText: self.mainNew.text];
    } else {
        
        CommentObject *object = [self.commentsArray objectAtIndex:indexPath.row - 2];
        return [PostCellTableView heightForCellText: object.text] + 10 ;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.commentsArray count] - 4) {
        
        [self generateComments];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.messegeCellHide = !self.messegeCellHide;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)sendCommentAction:(UIButton *)sender {
    
    
    SendTextCell *cell = (SendTextCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [[ServerManager sharedManager] postComment:cell.textView.text toOwnerId:self.mainNew.idForPost andItemID:self.mainNew.item_id userSuccess:^(bool success) {
        
        self.messegeCellHide = YES;
        [self refreshComments];
        
    } andFailture:nil];
    
}



@end

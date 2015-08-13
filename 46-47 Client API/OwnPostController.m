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

@interface OwnPostController ()

@property (strong, nonatomic) NSMutableArray *commentsArray;

@end


@implementation OwnPostController


- (void) viewDidLoad {
    
    self.commentsArray = [NSMutableArray array];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self generateComments];
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
    
    if (indexPath.row == 0) {
       
        PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:postCellKey];
        
        cell.navConroller = self.navigationController;
        cell.postFromWall = self.mainNew;
        cell.postText.text = self.mainNew.text;
        cell.likeLabel.text = [@(self.mainNew.likes) stringValue];
        cell.userId = self.mainNew.user.id;
        
        if (indexPath.row == 0) {
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
        
        
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        
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
    
    return 1 + [self.commentsArray count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [PostCellTableView heightForCellText: self.mainNew.text];
    } else {
        
        CommentObject *object = [self.commentsArray objectAtIndex:indexPath.row - 1];
        return [PostCellTableView heightForCellText: object.text] + 10 ;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.commentsArray count] - 5) {
        
        [self generateComments];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

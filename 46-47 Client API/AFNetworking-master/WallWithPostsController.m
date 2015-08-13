//
//  WallWithPostsController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 04.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "WallWithPostsController.h"

#import "ServerManager.h"
#import "Wall.h"
#import "PostCellTableView.h"
#import "SendTextCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+renderingPicture.h"
#import "Group.h"
#import "HeaderCell.h"
#import "OwnPostController.h"

@interface WallWithPostsController ()

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSMutableArray *allPosts;
@property (strong, nonatomic) User *loadUser;
@property (assign, nonatomic) BOOL chooseText;
@property (assign, nonatomic) CGRect originRect;
@property (strong, nonatomic) SendTextCell *cell;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (IBAction)sendPost:(UIButton *)sender;


@end

@implementation WallWithPostsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allPosts = [[NSMutableArray alloc] init];
    self.chooseText = NO;
    self.groupId = @"-58860049";
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    [[ServerManager sharedManager] getGroupFromID:@"58860049" userSuccess:^(Group *group) {
        
        self.group = group;
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    } andFailture:nil];
    
    self.loadUser = [ServerManager sharedManager].userForToken;
    if (!self.loadUser) {
        [self authorizeUser];
    }
    
}

- (void) refreshWall {
    
    self.allPosts = [NSMutableArray array];
    
    [[ServerManager sharedManager] getWallFromID:self.groupId
                                      withOffset:0
                                        andCount:[self.allPosts count]
                                     wallSuccess:^(NSMutableArray *array) {
                                         
                                         [self.allPosts addObjectsFromArray:array];
                                         
                                         [self.refreshControl endRefreshing];
                                         
                                         [self.tableView reloadData];
                                         
                                     }
                                     andFailture:^(NSError *error) {
                                         NSLog(@"Something wrong");
                                         [self.refreshControl endRefreshing];
                                     }];
}

- (void) authorizeUser {
    
    [[ServerManager sharedManager] authorizeUserWithSuccess:^(User *user) {
        
        self.loadUser = user;
        
    } andFailture:^(NSError *error) {
        
    }];
}

- (void) generatePosts {
    
    @synchronized (self.allPosts) {
        
    [[ServerManager sharedManager] getWallFromID:self.groupId
                                      withOffset: [self.allPosts count]
                                        andCount:4
                                     wallSuccess:^(NSMutableArray *array) {
                                         
                                         [self.allPosts addObjectsFromArray:array];
                                         
                                         [self.tableView reloadData];
                                         
                                     }
                                     andFailture:^(NSError *error) {
                                         NSLog(@"Something wrong");
                                     }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allPosts count] + 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *keyHeaderKey = @"Header";
    static NSString *previewSendTextKey = @"SendPostText";
    static NSString *sendTextKey = @"SendPost";
    static NSString *postCellKey = @"TextPostCellKey";
    static NSString *keyForCell = @"generatePostsCellKey";

    
    if (indexPath.row == 0) {
        
        HeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyHeaderKey];
        
        cell.nameLabel.text = self.group.name;
        
        NSURL *url = [NSURL URLWithString: self.group.photo_200];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak HeaderCell *weakCell = cell;
        weakCell.imageView.image = nil;
        
        [weakCell.imageView setImageWithURLRequest:request placeholderImage:nil success:^void(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
            
            weakCell.photo.image = image;
            [weakCell.photo renderingWithRadius:20];
            [weakCell layoutSubviews];
            
        } failure:^void(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
            
        }];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        if (self.chooseText) {
            
            PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:sendTextKey];
            
            return cell;
        
        } else {
            
            PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:previewSendTextKey];
            
            return cell;
            
        }
        
    }  if (indexPath.row == [self.allPosts count] + 2) {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForCell];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keyForCell];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Load more!!";
        cell.textLabel.textColor = [UIColor scrollViewTexturedBackgroundColor];
        
        return cell;
        
    } else {
        
        PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:postCellKey];
        cell.navConroller = self.navigationController;
        
        Wall *wall = [self.allPosts objectAtIndex:indexPath.row - 2];
        cell.postFromWall = wall;
        cell.postText.text = wall.text;
        cell.likeLabel.text = [@(wall.likes) stringValue];
        cell.userId = wall.user.id;
        
        if (indexPath.row - 2 > 0) {
            cell.nameAndLastName.text = [NSString stringWithFormat:@"%@ %@", wall.user.firstName, wall.user.lastName];
        }
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"ss dd/MM/YYYY"];
        cell.dateOfThePost.text = [formater stringFromDate:wall.date];
        
        NSURL *url = [NSURL URLWithString: wall.user.photo_100];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak PostCellTableView *weakCell = cell;
        weakCell.imageView.image = nil;
        weakCell.photosVideos = nil;
        
        [weakCell.imageView setImageWithURLRequest:request placeholderImage:nil success:^void(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
            
            weakCell.photo.image = image;
            
            [weakCell.photo renderingWithRadius:20];
            
            [weakCell layoutSubviews];
            
        } failure:^void(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
            
        }];
        
        return cell;
        
    }
    
        return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        return self.chooseText ? 120 : 40.f;
        
    } else if (indexPath.row == 0) {
        
        return 150.f;
        
    } else if ((indexPath.row != [self.allPosts count] + 2)) {
        
        Wall *wall = [self.allPosts objectAtIndex:indexPath.row - 2];
        return [PostCellTableView heightForCellText: wall.text];
        
    } else {
        
        return 50.f;
    }
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return YES;
    } else {
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = [NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section];
    
    if (indexPath.row == [self.allPosts count] + 2) {
        
        [self generatePosts];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else if (indexPath.row == 1) {
        
        
        self.chooseText = !self.chooseText;
        
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else if(indexPath.row == 0) {
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    } else  {
        
        
        self.chooseText = NO;
       
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    
    }

}

- (IBAction)sendPost:(UIButton *)sender {
    
    SendTextCell *cell = (SendTextCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *text = cell.textView.text;
    
    
    [[ServerManager sharedManager] postNewsOnId:self.groupId message:text witthSuccess:^(NSString *str) {
        
    } andFailture:^(NSError *error) {
        
    }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = [NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section];
    
    return indexPath;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"PostSegue"]) {
        
        OwnPostController *pvc = segue.destinationViewController;
        pvc.mainNew = [self.allPosts objectAtIndex:self.indexPath.row];
        
    }
}



@end

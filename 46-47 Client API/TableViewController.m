//
//  ViewController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "TableViewController.h"
#import "ServerManager.h"
#import "Wall.h"
#import "PostCellTableView.h"
#import "SendTextCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+renderingPicture.h"

@interface TableViewController ()

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSMutableArray *allPosts;
@property (strong, nonatomic) User *loadUser;
@property (assign, nonatomic) BOOL chooseText;
@property (assign, nonatomic) CGRect originRect;
@property (strong, nonatomic) SendTextCell *cell;

- (IBAction)sendPost:(UIButton *)sender;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allPosts = [[NSMutableArray alloc] init];
    self.chooseText = NO;
    self.groupId = @"-58860049";
    //self.groupId = @"202931095";
    [[ServerManager sharedManager] authorizeUserWithSuccess:^(User *user) {
        
        self.loadUser = user;
        
    } andFailture:^(NSError *error) {
        
    }];
    
}

- (void) generatePosts {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allPosts count] + 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if (indexPath.row == [self.allPosts count] + 1) {
        
        static NSString *keyForCell = @"cell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForCell];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keyForCell];
        }

        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Load more!!";
        cell.textLabel.textColor = [UIColor scrollViewTexturedBackgroundColor];
        
        return cell;
        
    } else if ((indexPath.row == 0)&&(self.chooseText == NO)) {

        static NSString *sendKey = @"SendPostText";

        SendTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:sendKey];
        
        return cell; }
    
    else if ((indexPath.row == 0)&&(self.chooseText == YES)) {
        
        static NSString *sendKeyComplite = @"SendPost";
        
        SendTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:sendKeyComplite];
        
        return cell;

    } else {
        
        static NSString *keyForPost = @"TextCell";
        
        PostCellTableView *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForPost];
        
        Wall *wall = [self.allPosts objectAtIndex:indexPath.row - 1];
        cell.postText.text = wall.text;
        cell.likeLabel.text = [@(wall.likes) stringValue];
        cell.nameAndLastName.text = [NSString stringWithFormat:@"%@ %@", wall.user.firstName, wall.user.lastName];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"ss dd/MM/YYYY"];
        cell.dateOfThePost.text = [formater stringFromDate:wall.date];

        NSURL *url = [NSURL URLWithString: wall.user.photo_100];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak PostCellTableView *weakCell = cell;
        weakCell.imageView.image = nil;
        
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
    
    if ((indexPath.row != [self.allPosts count] + 1) && (indexPath.row != 0)) {
        Wall *wall = [self.allPosts objectAtIndex:indexPath.row - 1];
        return [PostCellTableView heightForCellText: wall.text];
        
    } else if (indexPath.row == 0) {
      
        return self.chooseText ? 120 : 40.f;
        
    } else {
        
        return 50.f;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.allPosts count] + 1) {
        
        [self generatePosts];
        
    } else if (indexPath.row == 0) {
    
    self.chooseText = !self.chooseText;
    
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates]; } else {
            
            
            self.chooseText = NO;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
        }
    
}

- (IBAction)sendPost:(UIButton *)sender {

    SendTextCell *cell = (SendTextCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *text = cell.textView.text;
    
    
    [[ServerManager sharedManager] postNewsOnId:self.groupId message:text witthSuccess:^(NSString *str) {
     
     } andFailture:^(NSError *error) {
         
     }];
}

@end

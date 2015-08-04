//
//  LeftController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 01.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "LeftController.h"
#import "HeaderCell.h"
#import "UIView+renderingPicture.h"
#import "UIImageView+AFNetworking.h"
#import "ServerManager.h"

@interface LeftController ()

@property (strong, nonatomic) User *loadUser;

@end

@implementation LeftController

-(void) viewDidLoad {
    
    [super viewDidLoad];
    [self authorizeUser];
}


- (void) authorizeUser {
    
    [[ServerManager sharedManager] authorizeUserWithSuccess:^(User *user) {
        
        self.loadUser = user;
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        static NSString *key = @"keyHeaderIdentifier";
    
        HeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:key];
        
        if (!cell) {
            cell = [[HeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
        }
        

    
        User *user = [ServerManager sharedManager].userForToken;
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        NSURL *url = [NSURL URLWithString:user.photo_100];
        __weak HeaderCell *weakCell = cell;
        weakCell.photo.image = nil;
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        [weakCell.photo setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
            
            weakCell.photo.image = image;
            [weakCell.photo renderingWithRadius:30];
            [weakCell layoutSubviews];
  
            
        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
            
        }];
        
        return cell;
        
    } else {
        
        static NSString *keyCell = @"SomeCell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyCell];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keyCell];
            
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Group: IOSCourse";
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Massages";
            } 
        }
        
        return cell;
        
    }
    
    return [[UITableViewCell alloc] init];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (indexPath.row == 0) {
        return 100.f;
    } else {
        
        return 44.f;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

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

@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *allPosts;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allPosts = [[NSMutableArray alloc] init];
    
    [[ServerManager sharedManager] authorizeUserWithSuccess:^(User *user) {
        
        
        
        
    } andFailture:^(NSError *error) {
        
    }];
    
}

- (void) generatePosts {
    
    [[ServerManager sharedManager] getWallFromID:@"-58860049"
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
    
    return [self.allPosts count] + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *keyForCell = @"TextCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForCell];
    
    if (indexPath.row == [self.allPosts count]) {

        //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForCell];
        cell.textLabel.text = @"Load more!!";
        
        return cell;
    } else {
        
        //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keyForCell];
        
        Wall *wall = [self.allPosts objectAtIndex:indexPath.row];
        cell.textLabel.text = wall.text;
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.allPosts count]) {
        [self generatePosts];
    }
}
@end

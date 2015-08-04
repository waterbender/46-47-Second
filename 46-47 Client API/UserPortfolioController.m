//
//  UserPortfolioController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 02.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "UserPortfolioController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "AboutUser.h"
#import "User.h"
#import "UIView+renderingPicture.h"
#import "UsersFromPage.h"

@interface UserPortfolioController ()

@property (strong, nonatomic) AboutUser *about;

@end

@implementation UserPortfolioController

- (void) viewDidLoad {
    

    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeUserNotification:) name: ServerManagerUserForTokenDidChangeNotification object:nil];
    
    [self changeUserNotification:nil];

}
- (IBAction)touchUpButton:(UIButton*)sender {
    
    if (sender.tag == 1) {
        
        UsersFromPage *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UsersFromPage"];
        vc.choosen = ChoosenPeopleFriends;
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 0) {
        
        UsersFromPage *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UsersFromPage"];
        vc.choosen = ChoosenPeopleFollowers;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (sender.tag == 2) {
        
        UsersFromPage *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UsersFromPage"];
        vc.choosen = ChoosenPeopleSubscribes;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void) changeUserNotification : (NSNotification*) notification {

    User *user = [ServerManager sharedManager].userForToken;
    
    if (user) {
        
    [[ServerManager sharedManager] getAboutUserFromID:user.id userSuccess:^(AboutUser *about) {
        
        self.about = about;
        
        NSURL *url = [NSURL URLWithString:about.photo_max];
        [self.photo renderingWithRadius:60];
        [self.photo setImageWithURL: url];
        
        if (user) {
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", about.firstName, about.lastName];
            self.universityName.text = about.universityName;
            self.facultyName.text = about.facultyName;
            self.educationForm.text = about.educatioForm;
            if ([about.status length] > 0) {
                
                self.status.text = about.status;
            } else {
                
                self.status.text = @"-clear-";
            }
            
        }
        
        [self.tableView reloadData];
        
    } andFailture:^(NSError *error) {
        
    }];
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

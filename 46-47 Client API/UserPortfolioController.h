//
//  UserPortfolioController.h
//  46-47 Client API
//
//  Created by  ZHEKA on 02.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPortfolioController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel, *status, *educationForm, *facultyName, *universityName;



@end

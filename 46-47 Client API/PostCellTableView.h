//
//  PostCellTableView.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wall.h"

@interface PostCellTableView : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *postText, *likeLabel, *nameAndLastName, *dateOfThePost;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) Wall *postFromWall;
@property (strong, nonatomic) UINavigationController *navConroller;
@property (weak, nonatomic) IBOutlet UIView *photosVideos;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;


+ (CGFloat) heightForCellText : (NSString*) text;


@end

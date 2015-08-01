//
//  PostCellTableView.h
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCellTableView : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *postText, *likeLabel, *nameAndLastName, *dateOfThePost;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

+ (CGFloat) heightForCellText : (NSString*) text;

@end

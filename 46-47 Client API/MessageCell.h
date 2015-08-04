//
//  MessageCell.h
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel, *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

+ (CGFloat) heightForCellWithText : (NSString*) text;

@end


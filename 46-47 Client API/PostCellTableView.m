//
//  PostCellTableView.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "PostCellTableView.h"
#import "MessageWithUserController.h"
#import "TableViewController.h"
#import "ServerManager.h"

@implementation PostCellTableView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat) heightForCellText : (NSString*) text {
    
    CGFloat offset = 1;
    
    
    UIFont *font = [UIFont systemFontOfSize:17.f];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor grayColor];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode: NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                shadow, NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName
                                , nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2*offset, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dictionary context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset + 100;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.photo.frame, point)) {
        
        
        MessageWithUserController *mvc = [self.navConroller.storyboard instantiateViewControllerWithIdentifier:@"MessageWithUserController"];
        mvc.userID = self.userId;
        
        [self.navConroller pushViewController:mvc animated:YES];
        
    } else if (CGRectContainsPoint(self.likeView.frame, point)) {
        
        NSInteger numOfLikes = [self.likeLabel.text integerValue];
        
        [[ServerManager sharedManager] postLike:@"post" toUser:self.postFromWall.idForPost itemID:self.postFromWall.item_id userSuccess:^(NSInteger success) {
            
            
            if (success > numOfLikes) {
                
                self.likeLabel.text = [@(success) stringValue];
            } else if (numOfLikes == success) {
                
                self.likeLabel.text = [@(numOfLikes-1) stringValue];
                
                [[ServerManager sharedManager] postDeleteLike:@"post" toOwner:self.postFromWall.idForPost itemID:self.postFromWall.item_id userSuccess:^(NSInteger count) {
                    
                    
                    
                } andFailture:nil];
                
                
            }
            
        } andFailture:^(NSError *error) {
            
        }];
        
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    
    [super touchesEnded:touches withEvent:event];
}




@end

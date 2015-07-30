//
//  PostCellTableView.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "PostCellTableView.h"

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
    
    
    UIFont *font = [UIFont systemFontOfSize:14.f];
    
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
    
    return CGRectGetHeight(rect) + 2 * offset;
}

@end

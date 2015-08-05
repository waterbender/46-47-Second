//
//  MessageCell.m
//  46-47 Client API
//
//  Created by  ZHEKA on 03.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell



+ (CGFloat) heightForCellWithText : (NSString*) text {
    
    CGFloat offset = 1.f;
    
    CGFloat height = 15.f;
    UIFont *font = [UIFont systemFontOfSize:height];
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSTextAlignmentCenter];
    [paragraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                shadow, NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName,
                                nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dictionary context:nil];
    
    
    return CGRectGetHeight(rect) + offset;
}


@end

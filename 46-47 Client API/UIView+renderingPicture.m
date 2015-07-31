//
//  UIView+renderingPicture.m
//  46-47 Client API
//
//  Created by  ZHEKA on 31.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "UIView+renderingPicture.h"

@implementation UIView (renderingPicture)

- (void) renderingWithRadius: (NSInteger) radius {
    
    CALayer *layer = [self layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.borderWidth = 0.5;
    
}

@end

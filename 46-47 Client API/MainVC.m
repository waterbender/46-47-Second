//
//  MainVC.m
//  46-47 Client API
//
//  Created by  ZHEKA on 01.08.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "MainVC.h"

@implementation MainVC


-(NSString*) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    
    NSString *identifier = nil;
    
    switch (indexPath.row) {
        case 1:
            identifier = @"groupIdentifier";
            break;
            
        case 2:
            identifier = @"massagesIdentifier";
            break;
            
        case 0:
            identifier = @"ownProfile";
            break;
            
        default:
            break;
            
    }
    
    return identifier;
}


@end

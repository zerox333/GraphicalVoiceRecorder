//
//  LineView.h
//  line_drawing
//
//  Created by amorales on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView
{
    NSMutableArray *lines;
    CGFloat startX;
}

@property (strong, nonatomic) NSMutableArray *lines;

@end

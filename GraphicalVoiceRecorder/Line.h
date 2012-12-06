//
//  Line.h
//  line_drawing
//
//  Created by amorales on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject {
  CGPoint _fromPoint;
  CGPoint _toPoint;
  CGColorRef _color;
}

@property(nonatomic, assign) CGPoint fromPoint;
@property(nonatomic, assign) CGPoint toPoint;
@property(nonatomic, assign) CGColorRef color;

@end

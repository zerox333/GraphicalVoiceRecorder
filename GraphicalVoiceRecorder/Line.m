//
//  Line.m
//  line_drawing
//
//  Created by amorales on 5/7/12.
//
//  This is the actual class that knows how to draw a line

#import "Line.h"

@implementation Line

@synthesize fromPoint = _fromPoint;
@synthesize toPoint = _toPoint;
@synthesize color = _color;

- (id) init {
    self = [super init];
    
    _fromPoint = CGPointMake(0.0, 0.0);
    _toPoint = CGPointMake(0.0, 0.0);
    _color = [UIColor blueColor].CGColor;
    
    return self;
}

@end

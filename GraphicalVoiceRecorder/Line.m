//
//  Line.m
//  line_drawing
//
//  Created by amorales on 5/7/12.
//
//  This is the actual class that knows how to draw a line

#import "Line.h"

@implementation Line

@synthesize from_point = _from_point;
@synthesize to_point = _to_point;
@synthesize color = _color;

- (id) init {
    self = [super init];
    
    _from_point = CGPointMake(0.0, 0.0);
    _to_point = CGPointMake(0.0, 0.0);
    _color = [UIColor blueColor].CGColor; // default color
    
    return self;
}

@end

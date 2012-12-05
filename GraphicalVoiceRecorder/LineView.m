//
//  LineView.m
//  line_drawing
//
//  Created by amorales on 5/7/12.
//

#import "LineView.h"
#import "Line.h"

@implementation LineView

@synthesize lines = _lines;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        startX = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(!_lines)
    {
        _lines = [[NSMutableArray alloc] init];
    }
    
    startX -= 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, startX, 0);
    
    for(Line *line in _lines)
    {
        [self drawLine:line inContext:context];
    }
}

- (void)drawLine:(Line *)line inContext:(CGContextRef)context
{
    line.color = [UIColor colorWithRed:1.0 green:1.0 blue:line.to_point.y/255.0 alpha:1].CGColor;
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, line.color);
    CGContextMoveToPoint(context, line.from_point.x, line.from_point.y);
    CGContextAddLineToPoint(context, line.to_point.x, line.to_point.y);
    CGContextStrokePath(context);
}


@end

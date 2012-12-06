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
        _originX = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(!_lines)
    {
        _lines = [[NSMutableArray alloc] init];
    }
    
    _originX -= 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, _originX, 0);
    
    for(Line *line in _lines)
    {
        [self drawLine:line inContext:context];
    }
}

- (void)drawLine:(Line *)line inContext:(CGContextRef)context
{
    // 根据Y值改变颜色
    line.color = [UIColor colorWithRed:1.0 green:1.0 blue:line.toPoint.y/255.0 alpha:1].CGColor;
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, line.color);
    CGContextMoveToPoint(context, line.fromPoint.x, line.fromPoint.y);
    CGContextAddLineToPoint(context, line.toPoint.x, line.toPoint.y);
    CGContextStrokePath(context);
}


@end

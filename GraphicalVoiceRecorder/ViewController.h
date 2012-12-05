//
//  ViewController.h
//  GraphicalVoiceRecorder
//
//  Created by ding_yuanyi on 12-12-5.
//  Copyright (c) 2012年 zerox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LineView.h"
#import "Line.h"

@interface ViewController : UIViewController
{
    CGPoint _last_touch_point;
    AVAudioRecorder *recorder;
    CGFloat xValue;
}

@property(nonatomic, retain) LineView *lineView;
@property(nonatomic, retain) AVAudioRecorder *recorder;

- (void)addNewLineFromPoint:(CGPoint)from_point toPoint:(CGPoint)to_point offSet:(CGFloat)offSet;

@end

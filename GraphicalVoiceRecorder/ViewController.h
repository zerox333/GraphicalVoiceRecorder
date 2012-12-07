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
    CGPoint _lastPoint;             // 全局变量，记录上一点
    CGFloat _currentX;              // 当前横坐标
    LineView *_lineView;            // 线条视图
    AVAudioRecorder *_recorder;     // 录音
    NSTimer *_timer;                // 定时器
}

@end

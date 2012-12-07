//
//  ViewController.m
//  GraphicalVoiceRecorder
//
//  Created by ding_yuanyi on 12-12-5.
//  Copyright (c) 2012年 zerox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController(private)

// 录音初始化
- (void)initRecording;
// 加入新的点
- (void)addPointAt:(CGPoint)point;
// 加入新的线
- (void)addNewLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
// 更新分贝信息
- (void)updateMeters;

@end

@implementation ViewController

// 视图已加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 点赋初值
	_lastPoint = CGPointMake(-1.0, -1.0);
    
    // 实例化波形视图
    _lineView = [[LineView alloc] initWithFrame:self.view.bounds];
    _lineView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.view = _lineView;
    
    // 初始化录音
    [self initRecording];
    
    // 每0.1秒更新一次分贝信息
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(updateMeters)
                                   userInfo:nil
                                    repeats:YES];
}

// 视图已显示
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初始直线
    [self addPointAt:CGPointMake(0, 360)];
    [self addPointAt:CGPointMake(320, 360)];
    _currentX = 320;
}

// 对象销毁，释放内存
- (void)dealloc
{
    [_lineView release];
    [_recorder release];
    [super dealloc];
}

#pragma mark - Recording

- (void)initRecording
{
    // 录音设置
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; // mono
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    // 录音文件URL（存储于沙盒下tmp目录中）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    NSString *documentDirectoryPath = NSTemporaryDirectory();
	NSString *recordPath = [documentDirectoryPath stringByAppendingFormat:@"%@.wav",dateString];
	NSURL *url = [NSURL fileURLWithPath:recordPath];
	
	// 实例化Recorder
    NSError *error = nil;
	_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (error) // 实例化失败
	{
		NSLog(@"Error: %@", [error localizedDescription]);
        return;
	}
    else // 实例化成功
    {
        /* turns level metering on. default is off. */
        _recorder.meteringEnabled = YES;
    }
    
    //判断是否准备录音
	if (![_recorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
        return;
	}
    
	//录音失败删除创建的文件
	if (![_recorder record])
	{
		NSLog(@"Error: Record failed");
		//删除文件
		NSError *error;
		if (![[NSFileManager defaultManager] removeItemAtPath:[_recorder.url path] error:&error])
        {
			NSLog(@"Error: %@", [error localizedDescription]);
        }
        return;
	}
}

#pragma mark - Drawing

- (void)addPointAt:(CGPoint)point
{
    // 初始化起始点（至少两点才可开始画线）
    if(_lastPoint.x < 0)
    {
        _lastPoint = point; // 初始化起始点，不画线
    }
    else
    {
        [self addNewLineFromPoint:_lastPoint toPoint:point];
        [_lineView setNeedsDisplay]; // 重绘波形图
        _lastPoint = point; // _lastPoint赋新值
    }
}

- (void)addNewLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    // 实例化线条并加入数组
    Line *newLine = [[Line alloc] init];
    newLine.fromPoint = fromPoint;
    newLine.toPoint = toPoint;
    [[_lineView lines] addObject:newLine];
    [newLine release];
}

- (void)updateMeters
{
    [_recorder updateMeters];
    float avg = [_recorder averagePowerForChannel:0];//平均分贝功率（分贝数越大值越小）
    
    avg *= 4; // 4倍值，便于显示
    
    _currentX += 2;
	CGPoint point = CGPointMake(_currentX, 100 - avg);
    [self addPointAt:point];
}

@end

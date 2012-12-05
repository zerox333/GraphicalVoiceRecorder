//
//  ViewController.m
//  GraphicalVoiceRecorder
//
//  Created by ding_yuanyi on 12-12-5.
//  Copyright (c) 2012年 zerox. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize lineView;
@synthesize recorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
	_last_touch_point = CGPointMake(-1.0, -1.0);
    
    lineView = [[LineView alloc] initWithFrame:self.view.bounds];
    lineView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:lineView];
    
    // Recording settings
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; // mono
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    // File URL
    NSString *documentDirectoryPath = NSTemporaryDirectory();
	NSString *createMyrecord = [documentDirectoryPath stringByAppendingFormat:@"myrecord"];
	NSURL *url = [NSURL fileURLWithPath:createMyrecord];
	
	// Create recorder
    NSError *error = nil;
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (error)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
    else
    {
        recorder.meteringEnabled = YES;
    }
    
    //判断是否准备录音
	if (![recorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
	}
	//录音失败删除创建的文件
	if (![recorder record])
	{
		NSLog(@"Error: Record failed");
		//删除文件
		NSError *error;
		if (![[NSFileManager defaultManager] removeItemAtPath:[recorder.url path] error:&error])
			NSLog(@"Error: %@", [error localizedDescription]);
	}
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addPointAt:CGPointMake(0, 360)];
    [self addPointAt:CGPointMake(320, 360)];
    xValue = 320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [lineView release];
    [recorder release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    lineView.frame = self.view.bounds;
}

- (void)addNewLineFromPoint:(CGPoint)from_point toPoint:(CGPoint)to_point offSet:(CGFloat)offSet
{
    Line *new_line = [[Line alloc] init];
    new_line.from_point = from_point;
    new_line.to_point = to_point;
    for (Line *line in [lineView lines])
    {
        line.from_point = CGPointMake(line.from_point.x - offSet, line.from_point.y);
        line.to_point = CGPointMake(line.to_point.x - offSet, line.to_point.y);
    }
    [[lineView lines] addObject:new_line];
}

- (void)addPointAt:(CGPoint)point
{
    // first time
    if(_last_touch_point.x < 0)
    {
        _last_touch_point = point; //record the initial point, nothing to draw the first time
    }
    else
    {
        [self addNewLineFromPoint:_last_touch_point toPoint:point offSet:0];
        [lineView setNeedsDisplay]; //redraw the screen
        _last_touch_point = point; //now get ready for the next touch
    }
}

- (void)updateMeters
{
    [recorder updateMeters];
    float avg = [recorder averagePowerForChannel:0];//平均分贝功率
    //	float peak = [self.m_recorder peakPowerForChannel:0];//录音分贝的峰值
	NSLog(@"avgInt %f",avg);
    
    avg *= 4;
    
    xValue += 2;
	CGPoint point = CGPointMake(xValue, 100 - avg);
    [self addPointAt:point];
}

@end

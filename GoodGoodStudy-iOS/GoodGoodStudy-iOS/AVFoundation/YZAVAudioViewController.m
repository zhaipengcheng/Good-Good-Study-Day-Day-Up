//
//  YZAVAudioViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/28.
//

#import "YZAVAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface YZAVAudioViewController ()

@end

@implementation YZAVAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    // Category 向系统描述应用需要什么能力
    /**
     
     */
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
//    设置I/O Buffer 越小延迟越低
//    播放器一般 20-50ms
    NSTimeInterval bufferDuration = 0.001;
    [audioSession setPreferredIOBufferDuration:bufferDuration error:&error];
//    设置采样
    double sampleRate = 44100.0;
    [audioSession setPreferredSampleRate:sampleRate error:&error];
//    设置参数之后 可以激活
    [audioSession setActive:YES error:&error];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

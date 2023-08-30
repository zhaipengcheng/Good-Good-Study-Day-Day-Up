//
//  YZAlgorithmIPV4ViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/30.
//

#import "YZAlgorithmIPV4ViewController.h"

@interface YZAlgorithmIPV4ViewController ()

@end

@implementation YZAlgorithmIPV4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL isIPv4 = [self verifyIPv4:@"192.165.01.1"];
    NSLog(@"%d", isIPv4);
}

- (BOOL)verifyIPv4:(NSString *)ipStr {
    NSArray *sepArr = [ipStr componentsSeparatedByString:@"."];
    
    __block BOOL _filter = YES;
    if (sepArr.count == 4) {
        [sepArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger intValue = [str intValue];
            if(intValue <= 0 || intValue >= 255) {
                _filter = NO;
                *stop = YES;
            }
            
            if([[str substringWithRange:NSMakeRange(0, 1)] intValue] == 0) {
                _filter = NO;
                *stop = YES;
            }
            
        }];
    } else {
        return NO;
    }
    
    return _filter;
}

@end

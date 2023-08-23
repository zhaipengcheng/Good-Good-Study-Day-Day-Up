//
//  YZSingletonViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/23.
//

#import "YZSingletonViewController.h"
#import "YZSingleton.h"

@interface YZSingletonViewController ()

@end

@implementation YZSingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YZSingleton *singleton = [YZSingleton sharedSingleton];
    YZSingleton *singleton2 = [YZSingleton sharedSingleton];
    
    // 使用了NS_UNAVAILABLE之后 调用会提示报错
//    YZSingleton *singleton3 = [[YZSingleton alloc] init];
//    YZSingleton *singleton4 = [[YZSingleton alloc] new];
//    YZSingleton *singleton5 = [[YZSingleton alloc] copy];
//    YZSingleton *singleton6 = [[YZSingleton alloc] mutableCopy];

    NSLog(@"%@", singleton);
    NSLog(@"%@", singleton2);

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

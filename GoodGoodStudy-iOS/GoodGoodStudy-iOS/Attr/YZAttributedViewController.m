//
//  YZAttributedViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/29.
//

#import "YZAttributedViewController.h"

@interface YZAttributedViewController ()
@property (nonatomic, assign) NSUInteger currentIn;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableAttributedString *titleStr;
@end

@implementation YZAttributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIn = 1;
    
    self.label = [[UILabel alloc] init];
    self.label.numberOfLines = 0;
    self.label.frame = CGRectMake(0, 100, 300, 100);
    [self.view addSubview:self.label];
        
    NSString *iconName = @"qrcode_writeoff_type_icon";
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:iconName];
    NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    self.titleStr = [[NSMutableAttributedString alloc] initWithString:@"这是一段很长很长很长很长很长很长很长很长的文字"];
    [self.titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, self.titleStr.length)];
    [self.titleStr insertAttributedString:iconStr atIndex: self.currentIn];
    
    self.label.attributedText = self.titleStr;
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 400, 100, 40);
    [self.view addSubview:button];

}

- (void)buttonClick {
    NSString *iconName = @"qrcode_writeoff_type_icon";
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:iconName];
    NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attach];

    
    self.titleStr = [[NSMutableAttributedString alloc] initWithString:@"这是一段很长很长很长很长很长很长很长很长的文字"];
    [self.titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, self.titleStr.length)];

    self.currentIn ++;

    if (self.currentIn > self.titleStr.length) {
        return;
    }
    
    [self.titleStr insertAttributedString:iconStr atIndex: self.currentIn];
    
    self.label.attributedText = self.titleStr;

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

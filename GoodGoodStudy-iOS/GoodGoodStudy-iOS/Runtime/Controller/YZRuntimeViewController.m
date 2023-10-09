//
//  YZRuntimeViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/10/9.
//

#import "YZRuntimeViewController.h"
#import "UIButton+YZEventTimeInterval.h"

#import <objc/runtime.h>
#import "YZRuntimePerson.h"

@interface YZRuntimeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *intervalButton;

@end

@implementation YZRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.intervalButton.yz_acceptEventInterval = 2.0;
    
    
    [self msgForwardingFlow];
}

- (IBAction)intervalButtonClick:(UIButton *)sender {
    NSLog(@"interval button clicked");
}


/// 消息转发机制
/**
    1.动态方法解析 resolveInstanceMethod
    2.消息接受者重定向 forwardingTargetForSelector
    3.消息重定向 methodSignatureForSelector  --> forwardInvocation
    4.  doesNotRecognizeSelector 失败
 */
- (void)msgForwardingFlow {
    [self performSelector:@selector(fooMethod)];
}



void fooMethod(id obj, SEL _cmd) {
    NSLog(@"fooMethod ...");
}

/// 消息转发机制 第一阶段：动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
    
    if (sel == @selector(fooMethod)) {
        class_addMethod([self class], sel, (IMP)fooMethod , "v@:");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

/// 消息转发机制 第二阶段：消息接受者重定向
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
    
    if (aSelector == @selector(fooMethod)) {
        return [[YZRuntimePerson alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}


/// 消息转发机制 第三阶段：消息重定向
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(fooMethod)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    YZRuntimePerson *person = [[YZRuntimePerson alloc] init];
    
    if ([person respondsToSelector:sel]) {
        NSLog(@"forwardInvocation --- ");
        [anInvocation invokeWithTarget:person];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
    
}
/// 转发失败
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"消息转发失败");
}


@end

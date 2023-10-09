//
//  UIButton+YZEventTimeInterval.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/10/9.
//

#import "UIButton+YZEventTimeInterval.h"

#import <objc/runtime.h>

static const char *button_acceptEventInterval = "button_acceptEventInterval";
static const char *button_acceptEventTime = "button_acceptEventTime";
static const char *button_lastActionName = "button_lastActionName";

@implementation UIButton (YZEventTimeInterval)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(yz_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (NSTimeInterval)yz_acceptEventTime {
    return [objc_getAssociatedObject(self, button_acceptEventTime) doubleValue];
}

- (void)setYz_acceptEventTime:(NSTimeInterval)yz_acceptEventTime {
    objc_setAssociatedObject(self, button_acceptEventTime, @(yz_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSTimeInterval)yz_acceptEventInterval {
    return [objc_getAssociatedObject(self, button_acceptEventInterval) doubleValue];
}

- (void)setYz_acceptEventInterval:(NSTimeInterval)yz_acceptEventInterval {
    objc_setAssociatedObject(self, button_acceptEventInterval, @(yz_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)yz_lastActionName {
    return objc_getAssociatedObject(self, button_lastActionName);
}

- (void)setYz_lastActionName:(NSString *)yz_lastActionName {
    objc_setAssociatedObject(self, button_lastActionName, yz_lastActionName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    // 如果需要有一个统一间隔时间
    if (self.yz_acceptEventInterval <= 0.0) {
        // 默认0.1秒
        self.yz_acceptEventInterval = 0.1;
    }
    BOOL isOutInterval = NSDate.date.timeIntervalSince1970 - self.yz_acceptEventTime >= self.yz_acceptEventInterval;
    
    if (self.yz_acceptEventInterval > 0.0) {
        self.yz_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 有方法不能添加间隔判断
    /*
    NSString *method = NSStringFromSelector(action);
    if ([method isEqualToString:@"xxxxxx"]) {
        [self yz_sendAction:action to:target forEvent:event];
        return;
    }
     */

    if (isOutInterval) {
        [self yz_sendAction:action to:target forEvent:event];
    } else {
        if([self.yz_lastActionName isEqualToString:NSStringFromSelector(action)]) {
            // 同一个点击方法
            // 在时间间隔内连续点击
        } else {
            [self yz_sendAction:action to:target forEvent:event];
        }
    }
    self.yz_lastActionName = NSStringFromSelector(action);
}

@end

//
//  YZSingleton.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/23.
//

#import "YZSingleton.h"

@implementation YZSingleton
static YZSingleton *instance = nil;

+ (instancetype)sharedSingleton {
    // static 全局的变量
    // static 修饰的变量存储在静态存储区，只会在程序结束之后才释放
    
    // 线程不安全
    /*
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
    */
    
    // 线程同步保证线程安全
    /*
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
        return instance;
    }
     */

    
    // dispatch_once 本身就是线程安全
    // dispatch_once 执行时间要比 @synchronized 快
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZSingleton alloc] init];
    });
    return instance;
    
}


//+ (id)allocWithZone:(struct _NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[YZSingleton alloc] init];
//    });
//    return instance;
//}
//
//- (instancetype)copyWithZone:(NSZone *)zone {
////    return [YZSingleton sharedSingleton];
//    return instance;
//}
//
//- (instancetype)mutableCopyWithZone:(NSZone *)zone {
////    return [YZSingleton sharedSingleton];
//    return instance;
//}
@end

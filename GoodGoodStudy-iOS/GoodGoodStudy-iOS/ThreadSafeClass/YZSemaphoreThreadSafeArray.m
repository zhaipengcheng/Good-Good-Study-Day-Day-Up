//
//  YZSemaphoreThreadSafeArray.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/29.
//

#import "YZSemaphoreThreadSafeArray.h"


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);\
__VA_ARGS__;\
dispatch_semaphore_signal(_lock);\


@interface YZSemaphoreThreadSafeArray ()

@property (nonatomic, strong) NSMutableArray *mArr;
@property (nonatomic, strong) dispatch_semaphore_t lock;

@end


@implementation YZSemaphoreThreadSafeArray

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _mArr = [[NSMutableArray alloc] init];
    if (!_mArr) {
        return nil;
    }
//    if (self) {
//        _mDict = [[NSMutableDictionary alloc] init];
//        _lock = dispatch_semaphore_create(1);
//    }
    return self;
}

- (NSUInteger)count {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSUInteger c = _mArr.count;
    dispatch_semaphore_signal(_lock);
    return c;
}

- (id)objectAtIndex:(NSUInteger)index {
    LOCK(id obj = [_mArr objectAtIndex:index]);
    return obj;
}


- (void)addObject:(id)anObject {
    LOCK([_mArr addObject:anObject]);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    LOCK([_mArr insertObject:anObject atIndex:index]);
}

- (void)removeObject:(id)anObject {
    LOCK([_mArr removeObject:anObject]);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    LOCK([_mArr replaceObjectAtIndex:index withObject:anObject]);
}


@end

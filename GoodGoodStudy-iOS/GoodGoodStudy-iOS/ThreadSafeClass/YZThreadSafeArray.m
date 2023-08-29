//
//  YZThreadSafeArray.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/29.
//

#import "YZThreadSafeArray.h"


@interface YZThreadSafeArray ()

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation YZThreadSafeArray

- (instancetype)init {
    if (self = [super init]) {
        _mArray = [NSMutableArray new];
        _concurrentQueue = dispatch_queue_create("thread.safety.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        if (array) {
            _mArray = array.mutableCopy;
        } else {
            _mArray = [NSMutableArray new];
        }
        _concurrentQueue = dispatch_queue_create("thread.safety.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - read
- (NSUInteger)count {
    __block NSUInteger n;
    dispatch_sync(_concurrentQueue, ^{
        n = self.mArray.count;
    });
    return n;
}

- (id)objectAtIndex:(NSUInteger)index {
    __block id value = nil;
    
    dispatch_sync(_concurrentQueue, ^{
        if (_mArray.count > index) {
            value = [_mArray objectAtIndex:index];
        }
    });
    return value;
}

- (void)addObject:(id)anObject {
    dispatch_sync(_concurrentQueue, ^{
        [_mArray addObject:anObject];
    });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    dispatch_sync(_concurrentQueue, ^{
        if(_mArray.count >= index) {
            [_mArray insertObject:anObject atIndex:index];
        } else {
            
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_sync(_concurrentQueue, ^{
        if (_mArray.count > index) {
            [_mArray removeObjectAtIndex:index];
        }
    });
}


@end

//
//  YZThreadSafeDictionary.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/29.
//

#import "YZThreadSafeDictionary.h"

@interface YZThreadSafeDictionary ()

@property (nonatomic, strong) dispatch_queue_t safetyConcurrentQueue;
@property (nonatomic, strong) NSMutableDictionary *mDict;

@end

@implementation YZThreadSafeDictionary
- (instancetype)init {
    self = [super init];
    if (self) {
        _mDict = [NSMutableDictionary new];
        _safetyConcurrentQueue = dispatch_queue_create("safetyDictionaryQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    self = [super init];
    if (self) {
        if (otherDictionary) {
            _mDict = otherDictionary.mutableCopy;
        } else {
            _mDict = [NSMutableDictionary new];
        }
        _safetyConcurrentQueue = dispatch_queue_create("safetyDictionaryQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;

}

- (NSUInteger)count {
    __block NSUInteger n;
    dispatch_sync(_safetyConcurrentQueue, ^{
        n = self.mDict.count;
    });
    return n;
}

- (id)objectForKey:(id)aKey {
    __block id value;
    dispatch_sync(_safetyConcurrentQueue, ^{
        value = [self.mDict objectForKey:aKey];
    });
    return value;
}

- (NSArray *)allKeys {
    __block id value;
    dispatch_sync(_safetyConcurrentQueue, ^{
        value = [self.mDict allKeys];
    });
    return value;
}

- (NSArray *)allValues {
    __block id value;
    dispatch_sync(_safetyConcurrentQueue, ^{
        value = [self.mDict allValues];
    });
    return value;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    dispatch_barrier_sync(_safetyConcurrentQueue, ^{
        [self.mDict setObject:anObject forKey:aKey];
    });
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    dispatch_barrier_sync(_safetyConcurrentQueue, ^{
        [self.mDict addEntriesFromDictionary:otherDictionary];
    });
}

- (void)removeObjectForKey:(id)aKey {
    dispatch_barrier_sync(_safetyConcurrentQueue, ^{
        [self.mDict removeObjectForKey:aKey];
    });
}


@end

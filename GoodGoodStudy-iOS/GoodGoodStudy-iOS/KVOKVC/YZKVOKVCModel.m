//
//  YZKVOKVCModel.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/19.
//

#import "YZKVOKVCModel.h"

@implementation YZKVOKVCModel

@synthesize modelID = _modelID;
@synthesize name = _name;
@synthesize age = _age;
@synthesize score = _score;

- (void)setScore:(NSString *)score {
    if (score.floatValue < 60) {
        _score = score;
    } else {
        [self willChangeValueForKey:@"score"];
        _score = score;
        [self didChangeValueForKey:@"score"];
    }
}

@end

@implementation YZKVOKVCSubModel

@synthesize mathScore = _mathScore;

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (void)setMathScore:(NSString *)mathScore {
    _mathScore = mathScore;
    NSLog(@"%s - %@", __func__, mathScore);
}

- (NSString *)mathScore {
    return NSStringFromSelector(_cmd);
}

- (NSString*)getMathScore {
    return NSStringFromSelector(_cmd);
    
}

@end

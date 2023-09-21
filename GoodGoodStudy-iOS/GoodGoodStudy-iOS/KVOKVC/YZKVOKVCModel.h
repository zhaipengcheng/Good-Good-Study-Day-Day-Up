//
//  YZKVOKVCModel.h
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YZKVOKVCSubModel;
@interface YZKVOKVCModel : NSObject

@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, strong) YZKVOKVCSubModel *subModel;
@end

@interface YZKVOKVCSubModel : NSObject

@property (nonatomic, copy) NSString *mathScore;

@end


NS_ASSUME_NONNULL_END

//
//  UIButton+YZEventTimeInterval.h
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YZEventTimeInterval)

// 使用runtime关联对象为Catgory添加属性 assiciatedObject
@property (nonatomic, assign) NSTimeInterval yz_acceptEventInterval;    /// 发生间隔
@property (nonatomic, assign) NSTimeInterval yz_acceptEventTime;        /// 发生时间
@property (nonatomic, assign) NSString *yz_lastActionName;              /// 最后一个点击方法

@end

NS_ASSUME_NONNULL_END

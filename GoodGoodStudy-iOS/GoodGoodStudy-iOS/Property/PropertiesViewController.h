//
//  PropertiesViewController.h
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertiesViewController : UIViewController

/**

 Property 默认属性是：atomic、readwrite、assign
 
 @property = ivar + getter + setter
 
 原子性：atomic 和 nonatomic
 atomic（默认属性）：原子性，编译器会通过默认机制确保getter和setter完整性
 
 
 nonatomic：非原子性，不保证setter和getter的完整性
 
 */







@property (nonatomic, assign) NSInteger integerProperty;


@property (nonatomic, readwrite, copy) NSString *readWriteString;
@property (nonatomic, readonly, copy) NSString *readOnlyString;


@end

NS_ASSUME_NONNULL_END

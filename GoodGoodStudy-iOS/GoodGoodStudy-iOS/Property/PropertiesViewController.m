//
//  PropertiesViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/20.
//

#import "PropertiesViewController.h"

@interface PropertiesViewController ()


@end

@implementation PropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self arrayCopy];
}

- (void)arrayCopy {
    /*
     copy浅拷贝
     调用copyWithZone: 返回一个新的实例，这个实例是接收器的副本
     拷贝的指针地址，拷贝出来的对象与源对象地址一致，拷贝对象的值会影响源对象
     
     mutableCopy 深拷贝
     调用mutableCopyWithZone: 返回一个新的实例，这是一个可变的接收器的副本
     拷贝出来的对象与源对象地址不一致! 修改拷贝对象的值对源对象的值没有任何影响
     */
    
    /*
     不可变类型 copy 浅拷贝 return NSArray
     不可变类型 mutableCopy 深拷贝 return NSMutableArray
     
     可变类型 copy 深拷贝 return NSArray
     可变类型 mutableCopy 深拷贝 return NSMutableArray
     */
    
    /*
     只要是Copy，副本就是不可变的
     mutableCopy，副本是可变的
     浅拷贝深拷贝只代表是否复制了指针，元素对象指针拷贝
     */
    
    NSMutableArray *noneArray = [[NSMutableArray alloc] initWithObjects:@"张三", @"李四", nil];
    NSArray *originArray = [NSArray arrayWithArray:noneArray];
    NSArray *copyArray = [originArray copy];
    NSMutableArray *mutableCopyArray = [originArray mutableCopy];
    
    // 0x600001c6cc30 [张三，李四]
    NSLog(@"数组%p ==== %@", noneArray, noneArray);
    // 0x600001018010 [张三，李四]
    NSLog(@"原始不可变数组%p ==== %@", originArray, originArray);
    // 0x600001018010 [张三，李四]
    NSLog(@"Copy不可变数组%p ==== %@", copyArray, copyArray);
    // 0x600001c6cc00 [张三，李四]
    NSLog(@"MutableCopy不可变数组%p ==== %@", mutableCopyArray, mutableCopyArray);

    [noneArray addObject:@"王五"];
    [mutableCopyArray addObject:@"wangwu"];
    
    // 0x600001c6cc30 [张三，李四，王五]
    NSLog(@"修改后数组%p ==== %@", noneArray, noneArray);
    // 0x600001018010 [张三，李四]
    NSLog(@"修改后原始不可变数组%p ==== %@", originArray, originArray);
    // 0x600001018010 [张三，李四]
    NSLog(@"修改后Copy不可变数组%p ==== %@", copyArray, copyArray);
    // 0x600001c6cc00 [张三，李四，wangwu]
    NSLog(@"修改后MutableCopy可变数组%p ==== %@", mutableCopyArray, mutableCopyArray);
    
    NSLog(@"=============================");
    
    NSMutableArray *noneMArray = [[NSMutableArray alloc] initWithObjects:@"张三丰", @"李四鬼", nil];
    NSMutableArray *originMArray = [NSMutableArray arrayWithArray:noneMArray];
    NSArray *copyMArray = [originMArray copy];
    NSMutableArray *mutableCopyMArray = [originMArray mutableCopy];
    
    // 0x600000330f30 [张三，李四]
    NSLog(@"数组%p ==== %@", noneMArray, noneMArray);
    // 0x600000330c30 [张三，李四]
    NSLog(@"原始可变数组%p ==== %@", originMArray, originMArray);
    // 0x600000d103e0 [张三，李四]
    NSLog(@"Copy可变数组%p ==== %@", copyMArray, copyMArray);
    // 0x600000330fc0 [张三，李四]
    NSLog(@"MutableCopy可变数组%p ==== %@", mutableCopyMArray, mutableCopyMArray);

    [noneMArray addObject:@"王五人"];
    [mutableCopyMArray addObject:@"wangwuren"];
    
    // 0x600000330f30 [张三，李四，王五]
    NSLog(@"修改后数组%p ==== %@", noneMArray, noneMArray);
    // 0x600000330c30 [张三，李四]
    NSLog(@"修改后原始可变数组%p ==== %@", originMArray, originMArray);
    // 0x600000d103e0 [张三，李四]
    NSLog(@"修改后Copy可变数组%p ==== %@", copyMArray, copyMArray);
    // 0x600000330fc0 [张三，李四，wangwu]
    NSLog(@"修改后MutableCopy可变数组%p ==== %@", mutableCopyMArray, mutableCopyMArray);

    
}


@end

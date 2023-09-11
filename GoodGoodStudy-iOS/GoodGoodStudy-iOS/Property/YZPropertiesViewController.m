//
//  YZPropertiesViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/8/20.
//

#import "YZPropertiesViewController.h"
#import "YZPropertyModel.h"

@interface YZPropertiesViewController ()

@property (nonatomic, strong) YZPropertyModel *model;

@end


@implementation YZPropertiesViewController

// 可以不写
//@synthesize model = _model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YZPropertyModel *model = [[YZPropertyModel alloc] init];
    
    // 以下下三种均可以使用
    if (model.isBlue) {
        
    }
    
    if (model.blue) {
        
    }
    
    if ([model isBlue]) {
        
    }
    
   
//    [self testAssign:model];
    [self testStrongNSString:model];
    [self testCopyMutableString:model];
    
//    [self arrayCopy];
}

- (void)arrayCopy {
    /*
     当我们需要copy一个对象，或者mutableCopy一个对象，要遵守NSCopying和NSMutableCopying协议，实现copyWithZone: 和 木tableCopyWithZone: 两个方法，而不是重写copy和mutableCopy两个方法
     copy的返回值是不可变对象，mutableCopy的返回值是可变对象
     
     copy浅拷贝
     调用copyWithZone: 返回一个新的实例，这个实例是接收器的副本
     拷贝的指针地址，拷贝出来的对象与源对象地址一致，拷贝对象的值会影响源对象
     
     mutableCopy 深拷贝
     调用mutableCopyWithZone: 返回一个新的实例，这是一个可变的接收器的副本
     拷贝出来的对象与源对象地址不一致! 修改拷贝对象的值对源对象的值没有任何影响
     */
    
    /*
     不可变类型 copy 浅拷贝 只拷贝指针，地址相同 return NSArray
     不可变类型 mutableCopy 单层深拷贝 拷贝内容 return NSMutableArray
     
     可变类型 copy 单层深拷贝 拷贝内容 return NSArray
     可变类型 mutableCopy 打死你层深拷贝 return NSMutableArray
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

- (void)testAssign:(YZPropertyModel *)model {
    // assign修饰
    
    // 这里使用NSMutableString而不使用NSString是因为NSString会缓存字符串，后面置空的时候实际没有被销毁
    NSMutableString *nameS = [[NSMutableString alloc] initWithString:@"名字"];
    // 设置model.assignName不会增加nameS的引用计数，只是单纯将nameS指向的地址赋给model.assignName
    model.assignName = nameS;
    // 两个变量的内存地址一样
    NSLog(@"%@", model.assignName);
    NSLog(@"%p %p", model.assignName, nameS);
    [nameS appendString:@"++"];
    NSLog(@"%@", model.assignName);
    
    // 将nameS置为nil,引用计数为0，对象被销毁
    nameS = nil;
    // nameS变量地址为空
    NSLog(@"%p", nameS);
    //
    // 访问model内容或者model属性地址时发生野指针错误，程序崩溃。因为对象已经被销毁 EXC_BAD_ACCESS
    NSLog(@"%@", model.assignName);
    NSLog(@"%p", model.assignName);
}

- (void)testStrongNSString:(YZPropertyModel *)model {
    // strong 修饰 NSString
    NSMutableString *nameS = [[NSMutableString alloc] initWithString:@"名字"];
    // 讲可变字符串赋值给strongName
    model.strongName = nameS;
    // 两个变量的内存地址一样
    NSLog(@"%@ %@", model.strongName, nameS);
    // 两个变量的值一样
    NSLog(@"%p %p", model.strongName, nameS);
    // 修改 nameS 值
    [nameS appendString:@"++"];
    // 两个变量的内存地址依旧一样
    NSLog(@"%@ %@", model.strongName, nameS);
    // 两个变量的值也依旧一样
    NSLog(@"%p %p", model.strongName, nameS);

}

- (void)testCopyMutableString:(YZPropertyModel *)model {
    NSMutableString *nameS = [[NSMutableString alloc] initWithString:@"名字"];
    // 讲可变字符串赋值给copyMutableStringName
    model.mutableStringCopyName = nameS;
    // 两个变量的内存地址不一样
    NSLog(@"%@ %@", model.mutableStringCopyName, nameS);
    // 两个变量的值一样
    NSLog(@"%p %p", model.mutableStringCopyName, nameS);
    
    [nameS appendString:@"==="];
    // 两个变量的值不一样
    NSLog(@"%@ %@", model.mutableStringCopyName, nameS);

    // 修改属性 抛出异常 Attempt to mutate immutable object with appendString
    [model.mutableStringCopyName appendString:@"+++"];
    
}


#pragma mark - lazy
- (YZPropertyModel *)model {
    if (_model == nil) {
        //初始化操作，会调用setter方法
        self.model = [[YZPropertyModel alloc] init];
        //如果按照如下方法编写不会调用setter方法，如果自定义setter方法需要完成一些事情建议使用self.customObject的方式来设置
        //_model = [[YZPropertyModel alloc] init];
    }
    
    return _model;
}


@end

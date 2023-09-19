//
//  YZBlockViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/11.
//

#import "YZBlockViewController.h"

/*
 block 是 C 语言的拓展
 block 本质是一个OC对象，它内部也有isa指针，封装了函数及函数调用环境的OC对象
 
 block 的基础语法
 ^returnType(para1, para2, para3, ...) {
 
 }
 ^ 是 block 的标志，所有的 block 都必须以 ^ 开头
 returnType 是返回值类型，如果没有返回值 就用void表示
 
 block变量 的基础语法
 returnType (^blockName)(para1, para2, para3 ...);
 blockName以^开头，因为 ^是block的标志
 参数列表可以和声明函数一样，只写出形参类型
 
 */

// 定义一个 Block
// typedef returnType (^BlockTypeName)(para1, para2, para3, ...)
typedef void (^ResultBlock)(NSInteger);

@interface YZBlockViewController ()


@end

@implementation YZBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 无参数无返回值的 block，定义Block变量的时候不能省略返回值类型、block名称以及形参列表
    // 如果没有参数则用void占位或者不写
    void (^printBlock)(void) = ^ void(void) {
        NSLog(@"printBlock");
    };
    // 调用Block，与C语言调用函数一致
    printBlock();
    
    // 定义block时如果返回值为void可以省略，如果没有形参可以使用void占位或者整个形参列表都省略不写
    void (^printBlock2)(void) = ^ {
        NSLog(@"printBlock2");
    };
    printBlock2();
    
    // 有参数列表无返回值block
    void(^printBlock3)(NSString *) = ^(NSString *content) {
        NSLog(@"printBlock3 %@", content);
    };
    printBlock3(@"有参数");
    
    // 多个参数有返回值
    NSInteger (^addBlock)(NSInteger, NSInteger) = ^ NSInteger (NSInteger int1, NSInteger int2) {
        return int1+int2;
    };
    NSInteger sum = addBlock(1, 2);
    NSLog(@"sum is %ld", sum);
    
    
    
    
    
    
    // Block有三种类型
    // 1. NSGlobalBlock
    // block 没有访问外部局部变量，或者访问的是全局，或者静态局部变量，这时 block就是一个全局block，数据存储在全局区
    void (^exampleBlock)(void) = ^{
        //
        NSLog(@"exampleBlock");
    };
    NSLog(@"exampleBlock is %@", [exampleBlock class]);  // exampleBLock is __NSGlobalBlock__
    
    // 2.NSStackBlock
    // block访问了外部局部变量，此时的block是一个栈block，并存储在栈区
    // 由于栈区是系统控制释放，因此栈中的代码在作用域结束之后就会销毁，此时再次调用会导致crash
    int a1 = 10;
    void (^exampleBlock2)(void) = ^{
        NSLog(@"exampleBlock2 is %d", a1);
    };
    NSLog(@"exampleBlock2 is %@", [exampleBlock2 class]);  // ARC：exampleBlock2 is __NSMallocBlock__ ||| MRC：exampleBlock2 is: __NSStackBlock__
    
    
    // 3.NSMallocBlock
    // 当一个 __NSStackBlock__ 类型的block做copy操作之后就会将这个block从栈上复制到堆上，堆上的block类型就是__NSMallocBlock__，在ARC环境下，编译器会根据情况自动将Block从栈上copy到堆上，以下几种情况：
    
    //    3.1. block作为函数的返回值
    //    3.2. block赋值给__strong指针，或者赋值给block类型的成员变量
    //    3.3. block作为Cocoa API中方法名含有usingBlock的方法参数
    //    3.4. block作为GCD API 的方法参数
    
    
    
    // __block的作用
    // block捕获变量
    // block在执行之前的变量值修改并没有影响到block内部的代码，这是因为在定义block块的时候编译器已经在编译期将外部变量赋值给了block内部变量，即值捕获，此刻进行了一次值拷贝，而不是在运行时赋值，所以外部变量的修改并不会影响到内部block的输出
    // 如果值捕获是一个指针类型的变量，则外部的修改会影响到内部，跟函数传递形参一样，这个时候block内部或持有这个对象，并增加引用计数，block释放后，也会减少引用计数，此处需要注意循环引用
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    [mArray addObject:@"1"];
    void(^expBlock)(void) = ^ {
        // block
        [mArray addObject:@"2"];
    };
    expBlock();
    NSLog(@"mArray is %@", mArray); // [1, 2]
    
    
    // 使用__block在ARC环境中也可以防止循环引用
    int a2 = 300;
    void (^expBlock2)(void) = ^ {
        NSLog(@"a2 is %d", a2); // 300
    };
    a2 = 10000;
    expBlock2();
    NSLog(@"a2 - is %d", a2);   // 10000
    // 如果想让block捕获的变量在外部修改之后也可以影响到block内部，或者想在block内部修改捕获的变量，可以使用__block关键字
    __block int a3 = 300;
    void (^expBlock3)(void) = ^ {
        NSLog(@"a3 is %d", a3); // 10000
        a3 = 12345;
        NSLog(@"a3 is %d", a3); // 12345
    };
    a3 = 10000;
    expBlock3();
    NSLog(@"a3 - is %d", a3);   // 10000
    
    
    
    // __weak的作用
    // 防止循环引用
    // self本身会对block进行强引用，block也会对self形成强引用，因此造成了循环引用的为题，通过__weak打破循环，使block对象对self弱引用
    // 由于block对self的引用为weak弱引用，因此在block执行中，可能会出现self对象本身已经释放，所以要保证self对象不在block内部释放，需要用到__strong
    
    // __strong的作用
    // 防止block内部引用的外部weak变量被提前释放，使Block内部无法获取weak变量进行后续操作
    // 保证了在block作用域结束之前，block内部一直持有一个strongSelf对象可使用
    __weak __typeof(self) weakSelf = self;
    void(^weakBlock)(void) = ^ {
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf test1];
    };

    weakBlock();
    // 但是这种情况下，假如在weakSelf被释放之后执行 __strong __typeof(self) strongSelf = weakSelf，然后给self对象发送消息，OC的runtime消息转发机制允许给nil对象发送消息，不会导致crash
    // 但是，NSArray和NSDictionary的一些操作，会导致crash
    void(^weakBlock2)(void) = ^ {
        __strong __typeof(self) strongSelf = weakSelf;
        // 添加一层安全保护
        if (strongSelf) {
            [strongSelf test1];
        }
    };
    
    
#pragma mark - block作为参数
    // block作为参数传递
    NSArray *numA = @[@"1", @"2", @"3"];
    [self addNums:numA resultBlock:^(NSInteger num) {
        NSLog(@"pow (num, 2) = %ld", num * num);
    }];
    
    ResultBlock resultBlock = ^(NSInteger num) {
        NSLog(@"add(num, num) = %ld", num + num);
    };
    [self addNums:numA resultBlock:resultBlock];

}

- (void)test1 {
    NSLog(@"test 1");
}

- (void)addNums:(NSArray *)numArr resultBlock:(ResultBlock) resultBlock {
    NSUInteger count = [numArr count];
    for(NSUInteger i = 0; i < count; i++) {
        resultBlock([numArr[i] integerValue]);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

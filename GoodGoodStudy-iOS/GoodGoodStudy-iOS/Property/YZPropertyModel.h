//
//  YZPropertyModel.h
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 property是OC的一项特性，用于封装对象中的数据
 OC通常把所需要的数据保存为各种实例变量，实例变量通过存取方法来访问，即setter和getter
 
 
- 尽量使用 @property 定义类的属性
 尽量多的使用属性（property）而不是实例变量（attribute）因为属性（property）相比实例变量有很多的好处:
    - 自动合成getter和setter方法。当声明一个属性(property)的时候编译器默认情况下会自动生成相关的getter和setter方法
    - 更好的声明一组方法。因为访问方法的命名约定，可以很清晰的看出getter和setter的用处。
    - 属性(property)关键词能够传递出相关行为的额外信息。属性提供了一些可能会使用的特性来进行声明，包括 assign(vs copy),weak,strong,atomic(vs nonatomic),readwrite,readonly等
 
 
 - @property 的指示符：
    - atomic nonatomic
    - readwrite readonly
    - assign
    - strong
    - weak
    - copy
    - unsafe_unretained
    - retain
 
 
 原子性：atomic 和 nonatomic
 atomic（默认属性）：原子性访问，编译器会通过默认机制（锁定机制）确保getter和setter完整性
 但是atomic并不是绝对线程安全，A先成进行写操作后（写完成），B线程又进行写，A线程再读取就不一定是之前写入得值（可能是B的）。
 如果是MRC，C线程进行了release操作，会crash，破坏了线程安全，所以要添加锁等操作来保证线程安全。
 所以atomic只是了保证了存取方法的线程安全，并不能保证整个对象是线程安全的（如NAArray的objectAtIndex:就不是线程安全的，需要加锁等保证线程安全
 
 nonatomic：非原子性访问，不保证setter和getter的完整性
 本质来说就是去掉了atomic对getter和setter方法添加的锁，也就是getter和setter方法不是线程安全的，比如，当A线程进行写操作，B线程突然把未修改好的属性值提取出来，时候线程读到的值不一定是对的
 iOS中同步锁开销过大会带来性能问题，一般情况下不要求属性是atomic，因为其本身不能保证线程安全
 
 读写权限：readwrite readonly
 readwrite（编译器默认属性）：可读可选权限，若该属性由@synthesize修饰，自动生成对应的 getter 和 setter 方法
 readonly：只读权限，若该属性由@synthesize修饰，只生成 getter 方法，不生成 setter
 
 内存管理：assign strong weak copy retain unsafe_unretained
 
 assign 指针赋值，没有引用计数操作，对象销毁之后不会自动置为nil
 assign对属性只是简单的赋值操作，不更改赋值新值的引用计数，也不改变旧值的引用计数，常用语标量类型，NSInteget、NSUInteget、CGFloat、NSTimeInterval等。
 assign也可以修饰对象如NSString等类型对象，因为不改变引用计数，所以当新值的引用计数为0对象被销毁时，
 当前属性并不知道，编译器不会将该属性置为nil，指针仍然指向之前被销毁的内存，这个时候访问该属性会产生野指针，并crash，所以 assign 修饰的类型一定是标量类型。例子
 
 
 strong 强引用，引用计数+1
 strong表示属性对所赋值的对象强引用，是一种拥有关系，增加新值的引用计数，释放旧值减少引用计数
 修饰对象的引用计数会+1，当对象的引用计数为0时，对象就会在内存中释放
 通常修饰对象类型、可变集合、可变字符串

 retain 强引用，引用计数+1
 MRC下的强引用修饰词，跟strong同理，ARC中被 strong 代替
 
 weak 弱引用，没有引用计数操作，对象销毁之后自动置为nil
 weak 表示属性对所赋值的对象弱引用，是一种非拥有关系，所赋的值在引用计数为0被销毁后，weak修饰的属性会被自动置为nil能够有效防止野指针错误。
 weak 一般用来修饰代理 delegate，避免循环引用。
 weak 只能修饰对象类型
 
 copy  当调用修饰对象的 setter 方法时会建立一个新对象，引用计数+1，即对象会在内存里拷贝一个副本，两个指针指向不同的地址
 一般用来修饰有可变类型子类的对象：NSArray,NSDictionary,NSString
 为确保这些不可变对象因为可变子类对象影响，需要copy一份备份，如果不使用copy修饰，使用strong或assign等修饰则会因为多态导致属性值被修改。例子
 
 对于可变类型如NSMutableString、NSMutableArray、NSDictionary则不能用copy修饰，因为这些类都实现了NSCopying协议，使用copy方法返回的都是不可变对象
 如果使用copy修饰符在对可变对象赋值时会获取一个不可变对象，接下来如果对这个对象进行可变对象的操作会产生异常，因为没有mutableCopy修饰符，对于可变对象使用strong修饰符来修饰。例子
 copy还被用来修饰block
 
 
 
 unsafe_unretained 弱引用，没有引用计数操作，对象销毁之后不会自动置为nil
 不安全非拥有，类似 assign 非常少用 但只能修饰对象类型，不能修饰标量类型
 
 
 */


@interface YZPropertyModel : NSObject



//@property NSInteger age; // @property (atomic, readwrite, assign) NSInteger age;
//@property NSString *name; // @property (atomic, readwrite, strong) NSInteger *name;

// 属性生成
// 默认情况下 @property 是用 @synthesize （合成）修饰的（默认实现： @synthesize property = _property)，自动生成 ivar + setter + getter
// ivar 是实例变量 编译器自动生成 _属性名 的实例变量
// 例如
@property (nonatomic, readwrite, copy) NSString *name;


@property (nonatomic, readonly, getter=isBlue) BOOL blue;
// 制定setter方法名为 theNickname
@property (nonatomic, copy, setter=theNickname:) NSString *nickname;


@property (nonatomic, assign) NSString *assignName;
@property (nonatomic, strong) NSString *strongName;
@property (nonatomic, copy) NSMutableString *mutableStringCopyName;

@end

NS_ASSUME_NONNULL_END

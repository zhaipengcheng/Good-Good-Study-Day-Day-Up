//
//  YZKVOKVCViewController.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/19.
//

#import "YZKVOKVCViewController.h"
#import "YZKVOKVCModel.h"
#import <objc/runtime.h>

/**
 KVC(key-value-coding)键值编码，是由NSKeyValueCoding非正式协议启动的一种机制，对象采用协议来间接访问其属性。即可以通过一个字符串key来访问某个属性。
 
 KVC底层原理
 KVC 设值
 - 1. set<Key> _set<Key> setIs<Key>查找是否有这三种setter方法
 - 2.如果没有，调用 accessInstanceVariablesDirectly是否返回YES，查找间接访问的实例变量 _<key> _is<Key> <key> is<Key>
 - 3.如果没有找到setter或者实例变量，则调用 setValue:forUndefinedKey:方法，默认抛出一个异常，例子
 KVC取值
 - 1.get<Key> <key> is<Key> _<key>查找getter方法，找到，第五步
 - 2.没找到，查找 countOf<Key>\objectIn<Key>AtIndex:
 - 3.还没查到，那就查找countOf<Key>、enumeratorOf<Key>、memberOf<Key>方法
 - 4.没找到，accessInstanceVariablesDirectly返回YES
 - 5.根据搜索到的属性值的类型，返回不同的结果
 - 6.如果都失败了，valueForUndefinedKey:方法，抛出NSUndefinedKeyException异常
 
 KVO(key value observing)键值监听，在开发中使用的监听特定对象属性值变化的方法，一般用来监听数据模型的变化从而可以动态的修改对应视图。
 OC 在实现KVO的时候没有蚕蛹实现接口的方式，而是针对NSObject创建了一个类别，通过这样的方式使得NSObject的子类可以自行实现NSKeyValueObserving类别定义的相关方法
 因此可以对集合类型进行KVO的监听
 
 
 KVO底层实现原理
 KVO的实现使用了isa-swizzling技术以及观察者模式
 isa指针指向了对象的类对象，这个类对象维护这一个分发表，分发表保存了类方法、成员方法实现的指针
 
 当对一个对象的属性第一次进行监听器注册后，编译器会默认生成一个（NSKVONotifying_原有类名称）的派生中间类，这个类继承原有类，
 拍种类重写了setter方法、class、dealloc、_isKVOA方法
 然后修改原有类对象的isa指针，时期指向新生成的中间类，然后会在派生类中监听getter和setter方法，执行willChangeValueForKey和didChangeValueForKey方法，和父类的setter方法
 并通知所有的监听对象，监听属性被修改了
 移除KVO之后，实例对象isa指向由派生类改为原有类
 
 
 因此，对于使用KVO监听的类来说，isa指针指向的并不一定是指向对象的实际类，
 
 KVO是创建派生类实现了键值观察
 1、 addObserver，创建派生类、派生类是当前类的子类，重写了当前类被观察属性的setter方法，并将当前类的isa指向了派生类（所有调用本类的方法，调用的都是派生类，派生类没有，会沿着继承链查询到本类
 2、 派生类重写被监听属性的的setter方法，在派生类的setter触发时，willChange、didChange之间调用父类的setter方法，完成父类属性的赋值
 3、removeObserver之后，isa从派生类指回本类，但创建过的派生类不会被本类从子类列表里移除，会一直存在在内存中
 */

static void *YZKVOViewControllerScoreObserverContext = @"YZKVOViewControllerScoreObserverContext";
@interface YZKVOKVCViewController ()

@property (nonatomic, strong) YZKVOKVCModel *model;

@end

@implementation YZKVOKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[YZKVOKVCModel alloc] init];
    
    self.model.score = @"100";
    
    [self.model setName:@"YZ"];
    
    [self.model setValue:@"YZZ" forKey:@"name"];
    [self printClasses:[YZKVOKVCModel class]];
    [self.model addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:YZKVOViewControllerScoreObserverContext];
    [self printClasses:[YZKVOKVCModel class]];
    [self printClassAllMethod:object_getClass(@"NSKVONotifying_YZKVOKVCModel")];
    self.model.score = @"70";
    
    YZKVOKVCSubModel *subModel = [[YZKVOKVCSubModel alloc] init];
    subModel.mathScore = @"99.5";
    self.model.subModel = subModel;
    
    NSLog(@"submodel math score is %@", [self.model valueForKeyPath:@"subModel.mathScore"]);
    
    [self.model setValue:@"60" forKeyPath:@"subModel.mathScore"];
    NSLog(@"submodel math score is %@", [self.model valueForKeyPath:@"subModel.mathScore"]);

    [self.model.subModel valueForKey:@"mathScore"];
    
    NSLog(@"view did load");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if (object == self.model && [keyPath isEqualToString:@"score"]) {
//        NSLog(@"new score is %@", self.model.score);
//    }
    if (context == YZKVOViewControllerScoreObserverContext) {
        NSLog(@"new score is %@", self.model.score);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    NSLog(@"dealloc");
    [self.model removeObserver:self forKeyPath:@"score" context:YZKVOViewControllerScoreObserverContext];
}

- (void)printClasses:(Class)cls{

    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    // 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    // 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}

#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}


@end

//
//  YZPropertyModel.m
//  GoodGoodStudy-iOS
//
//  Created by 翟鹏程 on 2023/9/8.
//

#import "YZPropertyModel.h"

@implementation YZPropertyModel

// @synthesize 会自动生成 setter 和 getter 方法
// 但是也可以省略 @synthesize 关键字，让编译器自动合成 getter 和 setter 方法
// 单独重写 getter 和 setter 方法没有问题
// 如果同事重写 getter 和 setter 方法，系统部会自动生成 _property 变量，所以会报错
// 所以要同时重写 getter 和 setter 方法，要添加 @synthesize
@synthesize name = _name;


// 重写 getter 和 setter 方法
- (NSString *)name {
    //必须使用_name来访问属性值，使用self.name来访问值时编译器会自动转为调用该函数，会造成无限递归
    return _name;
}

- (void)setName:(NSString *)name {
    //必须使用_name来赋值，使用self.name来设置值时编译器会自动转为调用该函数，会导致无限递归
    //使用_name则是直接访问底层的存储属性，不会调用该方法来赋值
    //这里使用copy是为了防止NSMutableString多态
    if (_name != name) {
        _name = [name copy];
    }
}

- (void)theNickname:(NSString *)nickname {
    if(_nickname != nickname) {
        _nickname = [nickname copy];
    }
}

@end

# CheckLoginModule

[![CI Status](https://img.shields.io/travis/印聪/CheckLoginModule.svg?style=flat)](https://travis-ci.org/印聪/CheckLoginModule)
[![Version](https://img.shields.io/cocoapods/v/CheckLoginModule.svg?style=flat)](https://cocoapods.org/pods/CheckLoginModule)
[![License](https://img.shields.io/cocoapods/l/CheckLoginModule.svg?style=flat)](https://cocoapods.org/pods/CheckLoginModule)
[![Platform](https://img.shields.io/cocoapods/p/CheckLoginModule.svg?style=flat)](https://cocoapods.org/pods/CheckLoginModule)

## CheckLoginModule
`CheckLoginModule`主要是为了解决登录操作的后续逻辑。一般情况下我们在登录完成后通过代理或者`callback`的方式解决阻断操作连续性的问题，而通过这个库使用注解可以方便的在登录成功后自动执行注解对应的方法。

## 安装方式


```ruby
pod 'CheckLoginModule', :git => 'https://github.com/olderMonster/CheckLoginModule.git'
```

## 使用说明
如果是在OC类中使用，在需要登录权限的方法上注解即可。
`CheckLoginOC`需要两个参数，当前注解方法的`target`以及`action`
```
@CheckLoginOC(MTViewController,buyGoodsAction)
- (void)buyGoodsAction {
    [User createOrderAlertWithViewController:self];
}

```

如果是在`Swift`类中使用，那么需要将对应的方法使用`dynamic`修饰
同时需要新建一个`OC`的类，然后在其中声明注解，同时这边需要传入的参数除了`target`以及`action`意外还需要传入对应的`Module`
注意这里的`target`也需要使用`@objc`修饰

```
@interface CheckLoginImp()

@end

@implementation CheckLoginImp

@CheckLogin(DetailViewController,buyAction,CheckLoginModule_Example)
@CheckLogin(DetailViewController,jumpToMessagePage,CheckLoginModule_Example)


@end
```

## Author

印聪, cong.yin@metawall.ai

## License

CheckLoginModule is available under the MIT license. See the LICENSE file for more info.

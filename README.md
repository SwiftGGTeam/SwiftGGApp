# SwiftGG App 相关说明

[![Build Status](https://travis-ci.org/SwiftGGTeam/SwiftGGApp.svg?branch=master)](https://travis-ci.org/SwiftGGTeam/SwiftGGApp)

### 目录结构说明

1. 如果使用的第三方库不需要修改源文件，就放到 Podfile 里面，用 cocoapods 进行自动管理。
2. Library 目录下存放其他需要修改源代码的第三方库。
3. Models 目录下存放所有模型相关的类。
4. Modules 目录下是按业务模块进行划分的目录，目前建立了 Home（首页）和 UserCenter（个人中心）。业务模块下建立了三个子目录，分别是 Views，ViewControllers 和 Cells。Cells 用于存放 Cell 相关的子类， Views 用于存放非 Cell 相关的 View 子类, ViewControllers 用于存放 ViewController 相关类。
5. Utility 目录下存放一些常用的工具类。
6. 所有的图片资源都存放到 Assets 下。
7. 和界面展示的相关类，必须全部使用 AutoLayout。

### 代码规范说明

1. 我们所有新增的类都以 SG 作为前缀。
2. Swift 的相关 Coding Style 可以参考[这里](https://github.com/github/swift-style-guide)。
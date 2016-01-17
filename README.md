# SwiftGG App相关说明

![Travis CI](https://travis-ci.org/SwiftGGTeam/SwiftGGApp.svg?branch=master)

### 目录结构说明

1、如果使用的第三方库不需要修改源文件，就放到Podfile里面，用cocoapods进行自动管理

2、Library目录下存放其他需要修改源代码的第三方库

3、Models目录下存放所有模型相关的类

4、Modules目录下是按业务模块进行划分的目录，目前建立了Home(首页)和UserCenter(个人中心)。业务模块下建立了三个子目录，分别是Views, ViewControllers和Cells。Cells用于存放Cell相关的子类， Views用于存放非Cell相关的View子类, ViewControllers用于存放ViewController相关类。

5、Utility目录下存放一些常用的工具类

6、所有的图片资源都存放到Assets下

7、和界面展示的相关类，必须全部使用autolayout

### 代码规范说明

1、我们所有新增的类都以SG作为前缀

2、Swift的相关code style可以参考https://github.com/github/swift-style-guide
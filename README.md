# GGQ

> 这是一份 SwiftGG 客户端的 Rx 实现。

## Install

```
sh bootstrap.sh
```

### 项目进度

见 [Trello](https://trello.com/b/1eD37wyW) 。

## 基本规范

> 这里不再约束代码格式，主要谈一下如何写 View 和 ViewModel 层。

### View 层

#### 推荐

1. 尽量将子视图私有化
2. 尽量通过 `extension` 暴露变量
3. 减少直接通过 Model 设置 UI ，如果一定需要，加上因为无妨

#### 绝对禁止的

1. 不可以知道 ViewModel 和 ViewController 的存在
  > 也就是说不得以任何形式在 View 中主动关联其他层
2. 如果需要建立自管理的 View ，务必确保该业务与其他业务都不相关

### ViewModel 层

#### 推荐

1. 尽量将输入放到初始化中
2. 暴露属性做状态提供给 ViewController 或者其他人使用

> 有什么意见建议尽管提^^。

## Target

### GGQ-Release

Release 打包，不多说。

### GGQ-Dev

开发 Target 。

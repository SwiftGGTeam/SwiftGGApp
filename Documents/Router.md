# Router

使用 [RouterX](https://github.com/jasl/RouterX) 进行匹配。

- Scheme: `swiftgg`
- Host: `swift.gg`

目前支持以下 Router :

- [ ] 首页 `/:page`
- [x] OAuth认证 `/oauth/:type` （不对外使用）
- [x] 个人中心认证 `/profile/:type/:token` （不对外使用）
- [x] 某篇文章 `/:year/:month/:day/:pattern`
- [x] 某分类 `categories/:category_name`
- [x] 关于 `/about`
- [x] 搜索 `/search/:content`
- [x] 设置 `/setting`
- [ ] 归档 `archives/:year/:month`

## 例子

- 文章**[2016 版] 常见操作性能对比** [swiftgg://swift.gg/2016/05/25/friday-qa-2016-04-15-performance-comparisons-of-common-operations-2016-edition/](swiftgg://swift.gg/2016/05/25/friday-qa-2016-04-15-performance-comparisons-of-common-operations-2016-edition/)
- 分类 App

Coda [swiftgg://swift.gg/categories/AppCoda/](swiftgg://swift.gg/categories/AppCoda/)
- 关于 [swiftgg://swift.gg/about](swiftgg://swift.gg/about)
- 搜索 Swift [swiftgg://swift.gg/search/Swift](swiftgg://swift.gg/search/Swift)
- 设置 [swiftgg://swift.gg/setting](swiftgg://swift.gg/setting)

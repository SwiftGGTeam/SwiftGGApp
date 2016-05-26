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

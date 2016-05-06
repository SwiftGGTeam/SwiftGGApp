## Version 1000

### CHANGELOG

* ArticleInfoObject:
  * 添加: contentUrl: String
  * 添加: let readItLater = RealmOptional<Bool>()

## Version 0

### ArticleDetailModel

```swift
class ArticleDetailModel: Object {

    dynamic var id: Int = 0
    dynamic var typeId: Int = 0
    dynamic var typeName: String = ""
//    dynamic var tags: RLMArray = RLMArray(objectClassName: "String")
    dynamic var coverUrl: String = ""
    dynamic var contentUrl: String = ""
    dynamic var translator: String = ""
    dynamic var proofreader: String = ""
    dynamic var finalization: String = ""
    dynamic var author: String = ""
    dynamic var authorImageUrl: String = ""
    dynamic var originalDate: String = ""
    dynamic var originalUrl: String = ""
//    dynamic var description: String = ""
    dynamic var clickedNumber: Int = 0
    dynamic var submitDate: String = ""
    dynamic var starsNumber: Int = 0
    dynamic var commentsNumber: Int = 0
    dynamic var content: String = ""
//    dynamic var comments: RLMArray = RLMArray(objectClassName: "String")
    dynamic var updateDate: String = "" // 通过 updateDate 判断是否是最新版本文章
    dynamic var cacheData: NSData?
    let pagerTotal = RealmOptional<Int>()
    let currentPage = RealmOptional<Int>()
//    dynamic var

    override static func primaryKey() -> String? {
        return "id"
    }

}
```

### ArticleInfoObject

```swift
class ArticleInfoObject: Object {

	dynamic var id: Int = 0
	dynamic var typeId: Int = 0
	dynamic var typeName: String = ""
	dynamic var coverUrl: String = ""
	dynamic var authoerImageUrl: String = ""
	dynamic var submitDate: String = ""
	dynamic var title: String = ""
	dynamic var articleUrl: String = ""
	dynamic var translator: String = ""
	dynamic var articleDescription: String = ""
	dynamic var starsNumber: Int = 0
	dynamic var commentsNumber: Int = 0
	dynamic var updateDate: String = ""

	override static func primaryKey() -> String? {
		return "id"
	}
}
```

### CategoryObject

```swift
class CategoryObject: Object {

	dynamic var id = 0
	dynamic var name = ""
	dynamic var coverUrl = ""
	dynamic var sum = 0

	override static func primaryKey() -> String? {
		return "id"
	}
}
```

### ServerInfoModel

```swift
class ServerInfoModel: Object {

    dynamic var appVersion: String = ""
    dynamic var categoriesVersion: String = ""
    dynamic var articlesVersion: String = ""
    dynamic var articlesSum: Int = 0
    dynamic var message: String = ""

    override static func primaryKey() -> String? {
        return "appVersion"
    }

}
```

### UserModel

```swift
class UserModel: Object {

    dynamic var id: Int = 0
    dynamic var login: String = ""
    dynamic var avatar_url: String = ""
    dynamic var url: String = ""
    dynamic var blog: String?
    dynamic var email: String?
    dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

}
```

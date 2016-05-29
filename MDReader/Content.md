# 标题 1
## 标题 2

![ddd](http://swift.gg/img/wechat.jpg)

```swift
private extension UITextView {
func textRange(range: Range<Int>) -> UITextRange? {
let beginning = beginningOfDocument

guard let start = positionFromPosition(beginning, offset: range.startIndex) else {
return nil
}
guard let end = positionFromPosition(beginning, offset: range.endIndex) else {
return nil
}

return textRangeFromPosition(start, toPosition: end)
}
}
```

- 背景 1E2028
- Plain Text FFFFFF
- Comments 41B645
- String DB2C38
- Keywords B21889
- Class Name Function Type name 00A0BE
- Marcos C67C48


- 背景 000000
- 

> [Link](https://google.com) KKKKKKKKKKKKKK KKKKKKK KKKKKKK *KKKKK* KKKKKKKKKKKKK    KKKKKKKKKKKKKKKKKKKKKKKK **KKKK** KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK

```swift
let foo == bar
let foo == bar
let foo == bar
let foo == bar
let foo == bar
```

1. ddd KKKKKKKKKKKKKK KKKKKKK KKKKKKK *KKKKK* KKKKKKKKKKKKK    KKKKKKKKKKKKKKKKKKKKKKKK **KKKK** KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
2. eeee KKKKKKKKKKKKKK KKKKKKK KKKKKKK *KKKKK* KKKKKKKKKKKKK    KKKKKKKKKKKKKKKKKKKKKKKK **KKKK** KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
3. rrrrr [Link](https://google.com)

> KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK `KKKKKK` KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK[Link](https://google.com) [Link](https://google.com) [Link](https://google.com) GGGG


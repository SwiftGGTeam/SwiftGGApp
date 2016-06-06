//
//  Render.swift
//  SwiftMark
//
//  Created by 宋宋 on 5/7/16.
//  Copyright © 2016 DianQK. All rights reserved.
//

import UIKit
import CommonMark
import Kingfisher

private func handleImage(imageURL: NSURL, title: String?) -> NSMutableAttributedString {
    // TODO: - 处理图片的 title
    Info("Image URL: \(imageURL)")
    let mutableAttributedString = NSMutableAttributedString()
    let attach = GGImageAttachment()
    attach.imageURL = imageURL
    let attributedString = NSAttributedString(attachment: attach) as! NSMutableAttributedString
    mutableAttributedString.appendAttributedString(attributedString)
    return mutableAttributedString
}

typealias Render = NSMutableAttributedString -> NSMutableAttributedString

// TODO: - 换成函数式。。。

extension InlineElement {
    var text: String? {
        switch self {
        case .Text(let text):
            return text
        case .Html(let text):
            Warning(text)
            return text
        case .Strong(let elements):
            return elements.first?.text
        case .Emphasis(let children):
            return children.first?.text
        default:
//            #if DEV
//            fatalError("\(self)")
//            #else
            return nil
//            #endif
        }
    }
}

extension Block {
    var text: String? {
        switch self {
        case let .CodeBlock(text, _):
            return text
        case let .Paragraph(texts):
            return texts.first?.text
        default:
            #if DEV
                fatalError("\(self)")
            #else
                return nil
            #endif
        }
    }
}

func mdRender(markdown markdown: String) -> NSAttributedString {
    let node = Node(markdown: markdown)
    Info("\(node)")
    return node?.nrender() ?? NSAttributedString()
}

func mdRender(filename filename: String) -> NSAttributedString {
    let node = Node(filename: filename)
    Info("\(node)")
    return node?.nrender() ?? NSAttributedString()
}

extension Node {
    func nrender() -> NSMutableAttributedString {
        return render(elements)
    }
}

func render(items: [[Block]], type: ListType) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for (index, item) in items.enumerate() {
        attributedString.appendAttributedString(render(item, type: type, index: index))
    }
    return attributedString
}

func render(blocks: [Block], type: ListType, index: Int) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for (subIndex, block) in blocks.enumerate() {
        attributedString.appendAttributedString(render(block, type: type, index: index + 1, subIndex: subIndex))
    }
    return attributedString
}
// TODO: - 限制后面的 Render
func render(block: Block, type: ListType, index: Int, subIndex: Int) -> NSMutableAttributedString {
    let attributeString = NSMutableAttributedString()
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.firstLineHeadIndent += 20 // 首行缩进
    paragraphStyle.headIndent += 35
    // TODO: -
//    let attributeString = render(block).attributesAtIndex(0, effectiveRange: NSRangePointer)
    
    let attributes = [
        NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
        NSParagraphStyleAttributeName: paragraphStyle
    ]
    switch type {
    case .Unordered:
        let unordered = NSMutableAttributedString(string: "\u{2022} ", attributes: attributes)
        attributeString.appendAttributedString(unordered)
    case .Ordered:
        let ordered = NSMutableAttributedString(string: "\(index). ", attributes: attributes)
        attributeString.appendAttributedString(ordered)
    }
    let result = render(block)
    attributeString.appendAttributedString(result)
    return attributeString
}

// MARK: - 渲染 Block Quote

func renderBlockQuote(block: Block) -> NSMutableAttributedString {
    switch block {
    case let .Paragraph(text): // 普通的段落
        Info("Paragraph: \(text)")
        let attributedString = NSMutableAttributedString()
        attributedString.appendAttributedString(NSAttributedString(string: " \n"))
        attributedString.appendAttributedString(renderBlockQuote(text))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent += 20 // 首行缩进
        paragraphStyle.headIndent += 20
        let attributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
        let range = NSRange(location: 0, length: attributedString.length)
        
        attributedString.addAttributes(attributes, range: range)
        attributedString.appendAttributedString(NSAttributedString(string: "\n \n"))
        return attributedString
    default:
        #if DEV
//        fatalError()
        #endif
        return NSMutableAttributedString()
    }
}

func renderBlockQuote(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(renderBlockQuote(inlineElement))
    }
    return attributedString
}

// MARK: Block Quote 渲染结束

func renderBlockQuote(inlineElement: InlineElement) -> NSMutableAttributedString {
    switch inlineElement {
    case let .Code(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.red()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Custom(literal):
        Info("Warning Custom: \(literal)")
        return NSMutableAttributedString()
    case let .Emphasis(children): // *加强 斜体*
        
        if children.count > 1 {
            Warning("\(children)")
        }
        let renderChildren = renderBlockQuote(children)
        let attribute: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSObliquenessAttributeName: NSNumber(float: 0.2),
            NSForegroundColorAttributeName: R.color.gg.lightBlack()
        ]
        let range = NSRange(location: 0, length: renderChildren.length)
        renderChildren.setAttributes(attribute, range: range)
        return renderChildren
    case .Html:
        Info("Warning Html")
//        assert(false, "不渲染 Html")
        return NSMutableAttributedString()
    case let .Image(children, _, url):
        return handleImage(NSURL(string: url!)!, title: children.first?.text)
    case .LineBreak:
        return NSMutableAttributedString(string: "\n")
    case let .Link(children, _, url): // 遇到链接不继续向下处理
        guard let element = children.first else { fatalError("没有名字") }
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.blue(),
            NSLinkAttributeName: url ?? ""
        ]
        return NSMutableAttributedString(string: element.text ?? url ?? "", attributes: attributes)
    case .SoftBreak:
        return NSMutableAttributedString(string: " ")
    case .Strong(let children):
        if children.count > 1 {
            Warning("\(children)")
        }
        let renderChildren = renderBlockQuote(children)
        let attribute: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.lightBlack()
        ]
        let range = NSRange(location: 0, length: renderChildren.length)
        renderChildren.setAttributes(attribute, range: range)
        return renderChildren
    case .Text(let text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.lightBlack()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}

func render(blocks: [Block]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for block in blocks {
        attributedString.appendAttributedString(render(block))
    }
    return attributedString
}

/// 斜体组的渲染
func renderEmphasis(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(renderEmphasis(inlineElement))
    }
    return attributedString
}

func renderEmphasis(inlineElements: InlineElement) -> NSMutableAttributedString {
    switch inlineElements {
    case .Text(let text):
        let attribute: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSObliquenessAttributeName: NSNumber(float: 0.2)
        ]
        return NSMutableAttributedString(string: text, attributes: attribute)
    default:
        Info("Warning Emphasis miss.")
        return NSMutableAttributedString()
    }
}
// 加粗的渲染
func renderStrong(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(renderStrong(inlineElement))
    }
    return attributedString
}

func renderStrong(inlineElements: InlineElement) -> NSMutableAttributedString {
    switch inlineElements {
    case .Text(let text):
        let attribute: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!,
            NSObliquenessAttributeName: NSNumber(float: 0.2)
        ]
        return NSMutableAttributedString(string: text, attributes: attribute)
    case let .Link(childrens, _, url):
        guard let children = childrens.first else { fatalError("没有名字") }
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.blue(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSLinkAttributeName: url ?? ""
        ]
        return NSMutableAttributedString(string: children.text ?? url ?? "", attributes: attributes)
    default:
        Info("Warning Emphasis miss.")
        return NSMutableAttributedString()
    }
}

func renderParagraph(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(render(inlineElement))
    }
    attributedString.appendAttributedString(NSAttributedString(string: "\n \n"))
//    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
    return attributedString
}

/**
 对标题的渲染，完成
 
 - parameter inlineElements: 元素
 - parameter level:          标题级别
 
 - returns: NSMutableAttributedString
 */
func render(inlineElements: [InlineElement], level: Int) -> NSMutableAttributedString {
    guard let _ = inlineElements.first else { fatalError("不必要的执行") }
    let attributedString = NSMutableAttributedString()
    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
    for inlineElement in inlineElements {
        
            let size = CGFloat(25 - level * 2)
            switch inlineElement {
            case .Text(let text):
                let attributes = [
                    NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: size)!,
                    NSForegroundColorAttributeName: R.color.gg.black()
                    ]
                attributedString.appendAttributedString(NSMutableAttributedString(string: text, attributes: attributes))
            case .SoftBreak:
                /// 没有效果？
                attributedString.appendAttributedString(NSMutableAttributedString(string: "\n"))
            case .LineBreak:
                attributedString.appendAttributedString(NSMutableAttributedString(string: "\n"))
            case let .Code(text):
                let attributes = [
                    NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: size)!,
                    NSForegroundColorAttributeName: R.color.gg.red()
                ]
                let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
                attributedString.appendAttributedString(attributedString)
            case let .Link(childrens, _, url): // 遇到链接不继续向下处理
                guard let children = childrens.first else { fatalError("没有名字") }
                let attributes = [
                    NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: size)!,
                    NSForegroundColorAttributeName: R.color.gg.blue(),
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                    NSLinkAttributeName: url ?? ""
                ]
                attributedString.appendAttributedString(NSMutableAttributedString(string: children.text ?? "", attributes: attributes))
            case .Strong(let children):
                Info("Warning Strong: \(children))")
//                return render(children, level: level)
            case let .Custom(literal):
                Info("Warning Custom: \(literal)")
            case let .Emphasis(children): // *加强 斜体*
                //                return render(children, level: 4)
                Info("Warning Emphasis: \(children)")
            case .Html:
                Info("Warning Html")
            case .Image:
                Info("Warning Image")
            }
    }
    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
    return attributedString
}
// MARK: - 这个当做最外层， 从这里找下一个 case
func render(block: Block) -> NSMutableAttributedString {
    switch block {
    case .BlockQuote(let items): // 注释 搞定
//        assert(items.count == 1, "Block 数量有误")
        Info("Block: \(items)")
        return items.map(renderBlockQuote).reduce(NSMutableAttributedString(), combine: { (a, b) -> NSMutableAttributedString in
            a.appendAttributedString(b)
            return a
        })
//        let attributedString = renderBlockQuote(items.first!)
//        return attributedString
    case let .CodeBlock(text, language): // 已到底
        Info("CodeBlock: \(text)")
        
        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 0.7
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 10)!,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSBackgroundColorAttributeName: UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1) // TODO: 
        ]
        
        let paragraphContentStyle = NSMutableParagraphStyle()
        paragraphContentStyle.firstLineHeadIndent += 10 // 首行缩进
        paragraphContentStyle.headIndent += 10
        paragraphContentStyle.tailIndent -= 5
//        paragraphContentStyle.paragraphSpacing = 3
        
        let contentAttributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!,
            NSParagraphStyleAttributeName: paragraphContentStyle,
            NSBackgroundColorAttributeName: UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1) // TODO:

        ]

        let codeAttributedString = NSMutableAttributedString(string: text, attributes: contentAttributes)
        
        if let language = language {
            switch language.lowercaseString {
            case "swift":
                let langScope = SwiftLang().documentScope
                langScope.theme = JLColorTheme.Default
                langScope.cascadeAttributedString(codeAttributedString)
                langScope.perform()
                case "c":
                    let langScope = SwiftLang().documentScope
                    langScope.theme = JLColorTheme.Default
                    langScope.cascadeAttributedString(codeAttributedString)
                    langScope.perform()
                case "objective-c":
                    let langScope = SwiftLang().documentScope
                    langScope.theme = JLColorTheme.Default
                    langScope.cascadeAttributedString(codeAttributedString)
                    langScope.perform()
            default:
                break
            }
            
        }

        let attributedString = NSMutableAttributedString(string: "\n", attributes: attributes)
        attributedString.appendAttributedString(codeAttributedString)
        attributedString.appendAttributedString(NSMutableAttributedString(string: "\n", attributes: attributes))
        return attributedString
    case .Custom(let literal):
        Info("Custom: \(literal)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.black()
        ]
        Info("Custom: \(literal)")
        return NSMutableAttributedString(string: literal, attributes: attributes)
    case let .Heading(texts, level):
        Info("Heading: \(texts)")
        return render(texts, level: level)
    case let .Html(text):
        Info("Html: \(text)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!,
            NSForegroundColorAttributeName: R.color.gg.black()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .List(items, type):
        Info("List: \(type)")
        // TODO: - type
        return render(items, type: type)
    case let .Paragraph(text): // 普通的段落
        Info("Paragraph: \(text)")
        return renderParagraph(text)
    case .ThematicBreak: // 标题的换行， Section
        // TODO: - type
        Info("ThematicBreak")
        return NSMutableAttributedString(string: "-----------\n")
    }
}
/// 标题的渲染


/// 一般文本的渲染
func render(inlineElement: InlineElement) -> NSMutableAttributedString {
    switch inlineElement {
    case let .Code(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 16)!,
            NSForegroundColorAttributeName: R.color.gg.red()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Custom(literal):
        Info("Warning Custom: \(literal)")
        return NSMutableAttributedString()
    case let .Emphasis(children): // *加强 斜体*
        return renderEmphasis(children)
    case .Html:
        Info("Warning Html")
        return NSMutableAttributedString()
    case let .Image(children, _, url):
        return handleImage(NSURL(string: url!)!, title: children.first?.text)
    case .LineBreak:
        return NSMutableAttributedString(string: "\n")
    case let .Link(childrens, _, url): // 遇到链接不继续向下处理
        guard let children = childrens.first else { fatalError("没有名字") }
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.blue(),
//            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSLinkAttributeName: url ?? ""
        ]
        return NSMutableAttributedString(string: children.text ?? url ?? "", attributes: attributes)
    case .SoftBreak:
        return NSMutableAttributedString(string: " ")
    case .Strong(let children):
        return renderStrong(children)
    case .Text(let text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: R.color.gg.black()
            ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}

//func render(code: String, language: String) -> NSMutableAttributedString {
////    return
//}
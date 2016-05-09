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
    print(node)
    return node?.nrender() ?? NSAttributedString()
}

func mdRender(filename filename: String) -> NSAttributedString {
    let node = Node(filename: filename)
    print(node)
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
        attributedString.appendAttributedString(render(block, type: type, index: index, subIndex: subIndex))
    }
    return attributedString
}

func render(block: Block, type: ListType, index: Int, subIndex: Int) -> NSMutableAttributedString {
    let attributeString = NSMutableAttributedString()
    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.firstLineHeadIndent = 20 // 首行缩进
    paragraphStyle.headIndent = 38
    // TODO: -
//    let attributeString = render(block).attributesAtIndex(0, effectiveRange: NSRangePointer)
    
    let attributes = [
        NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
        NSParagraphStyleAttributeName: paragraphStyle
    ]
    switch type {
    case .Unordered:
        let unordered = NSMutableAttributedString(string: "  \u{2022} ", attributes: attributes)
        attributeString.appendAttributedString(unordered)
    case .Ordered:
        let ordered = NSMutableAttributedString(string: "  \(index). ", attributes: attributes)
        attributeString.appendAttributedString(ordered)
    }
    let result = render(block)
    attributeString.appendAttributedString(result)
//    print(attributeString)
//    attributeString.addAttributes(attributes, range: NSRange(location: 0, length: attributeString.length))
//    print(attributeString)
    return attributeString
}

func render(items: [[Block]]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for item in items {
        attributedString.appendAttributedString(render(item))
    }
    return attributedString
}

func renderBlockQuote(blocks: [Block]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for block in blocks {
        attributedString.appendAttributedString(renderBlockQuote(block))
    }
    return attributedString
}

func renderBlockQuote(block: Block) -> NSMutableAttributedString {
    switch block {
    case .BlockQuote(let items): // 注释
        print("Block: \(items)")
        return renderBlockQuote(items)
    case let .CodeBlock(text, _): // 已到底
        print("CodeBlock: \(text)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!,
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .List(items, type): // 暂时不考虑
        print("Warning List: \(type)")
        // TODO: - type
        return render(items, type: type)
    case let .Paragraph(text): // 普通的段落
        print("Paragraph: \(text)")
        return renderParagraph(text)
    case .ThematicBreak: // 标题的换行， Section
        // TODO: - type
        print("ThematicBreak")
        return NSMutableAttributedString(string: "-----------\n ")
    default:
        return NSMutableAttributedString()
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
        print("Warning Emphasis miss.")
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
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSLinkAttributeName: url ?? ""
        ]
        return NSMutableAttributedString(string: children.text ?? url ?? "", attributes: attributes)
    default:
        print("Warning Emphasis miss.")
        return NSMutableAttributedString()
    }
}

func renderBlockQuote(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(render(inlineElement))
    }
    return attributedString
}

func renderParagraph(inlineElements: [InlineElement]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(render(inlineElement))
    }
    attributedString.appendAttributedString(NSAttributedString(string: "\n "))
//    attributedString.appendAttributedString(NSAttributedString(string: "\n "))
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
    for inlineElement in inlineElements {
        
            let size = CGFloat(25 - level * 2)
            switch inlineElement {
            case .Text(let text):
                let attributes = [
                    NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: size)!,
                    ]
                attributedString.appendAttributedString(NSMutableAttributedString(string: text, attributes: attributes))
            case .SoftBreak:
                /// 没有效果？
                attributedString.appendAttributedString(NSMutableAttributedString(string: "\n "))
            case .LineBreak:
                attributedString.appendAttributedString(NSMutableAttributedString(string: "\n "))
            case let .Code(text):
                let attributes = [
                    NSFontAttributeName: UIFont(name: "Menlo-Regular", size: size)!,
                    NSForegroundColorAttributeName: UIColor.redColor()
                ]
                let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
                attributedString.appendAttributedString(attributedString)
            case let .Link(childrens, _, url): // 遇到链接不继续向下处理
                guard let children = childrens.first else { fatalError("没有名字") }
                let attributes = [
                    NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: size)!,
                    NSForegroundColorAttributeName: UIColor.blueColor(),
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                    NSLinkAttributeName: url ?? ""
                ]
                attributedString.appendAttributedString(NSMutableAttributedString(string: children.text ?? "", attributes: attributes))
            case .Strong(let children):
                print("Warning Strong: \(children))")
//                return render(children, level: level)
            case let .Custom(literal):
                print("Warning Custom: \(literal)")
            case let .Emphasis(children): // *加强 斜体*
                //                return render(children, level: 4)
                print("Warning Emphasis: \(children)")
            case .Html:
                print("Warning Html")
            case .Image:
                print("Warning Image")
            }
    }
    attributedString.appendAttributedString(NSAttributedString(string: "\n "))
    return attributedString
}
// MARK: - 这个当做最外层， 从这里找下一个 case
func render(block: Block) -> NSMutableAttributedString {
    switch block {
    case .BlockQuote(let items): // 注释
        print("Block: \(items)")
        return renderBlockQuote(items)
    case let .CodeBlock(text, _): // 已到底
        print("CodeBlock: \(text)")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20 // 首行缩进
        paragraphStyle.headIndent = 20
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        let attributedString = NSMutableAttributedString(string: "\n " + text, attributes: attributes)
        attributedString.appendAttributedString(NSAttributedString(string: "\n "))
        return attributedString
    case .Custom(let literal):
        print("Custom: \(literal)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!
        ]
        print("Custom: \(literal)")
        return NSMutableAttributedString(string: literal, attributes: attributes)
    case let .Heading(texts, level):
        print("Heading: \(texts)")
        return render(texts, level: level)
    case let .Html(text):
        print("Html: \(text)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .List(items, type):
        print("List: \(type)")
        // TODO: - type
        return render(items, type: type)
    case let .Paragraph(text): // 普通的段落
        print("Paragraph: \(text)")
        return renderParagraph(text)
    case .ThematicBreak: // 标题的换行， Section
        // TODO: - type
        print("ThematicBreak")
        return NSMutableAttributedString(string: "-----------\n ")
    }
}
/// 标题的渲染


/// 一般文本的渲染
func render(inlineElement: InlineElement) -> NSMutableAttributedString {
    switch inlineElement {
    case let .Code(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.redColor()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Custom(literal):
        print("Warning Custom: \(literal)")
        return NSMutableAttributedString()
    case let .Emphasis(children): // *加强 斜体*
        return renderEmphasis(children)
    case .Html:
        print("Warning Html")
        return NSMutableAttributedString()
    case let .Image(_, _, url):
//        let attributeString = NSMutableAttributedString()
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.firstLineHeadIndent = 20 // 首行缩进
//        paragraphStyle.headIndent = 38
        
        // TODO: - 处理图片的 title
        print("2 Image")
        let mutableAttributedString = NSMutableAttributedString()
        let attach = GGImageAttachment()
        let image = UIImage(named: "img_placeholder")//R.image.img_placeholder()!
        attach.image = image
        attach.imageURL = NSURL(string: url!)
//        attach.bounds = CGRect(origin: CGPoint(x: 20, y: 200), size: image.size)
        let attributedString = NSAttributedString(attachment: attach) as! NSMutableAttributedString
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .Center
//        let attribute = [
//            NSParagraphStyleAttributeName: paragraphStyle
//        ]
//        let range = NSRange(location: 0, length: attributedString.length)
//        attributedString.setAttributes(attribute, range: range)
        
        mutableAttributedString.appendAttributedString(attributedString)
//        let lineBreak = NSAttributedString(string: "\n ")
//        mutableAttributedString.appendAttributedString(lineBreak)
        return mutableAttributedString
    case .LineBreak:
        return NSMutableAttributedString(string: "\n ")
    case let .Link(childrens, _, url): // 遇到链接不继续向下处理
        guard let children = childrens.first else { fatalError("没有名字") }
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
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
            ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}

func renderBlockQuote(inlineElement: InlineElement) -> NSMutableAttributedString {
    switch inlineElement {
    case let .Code(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.redColor()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Custom(literal):
        print("Warning Custom: \(literal)")
        return NSMutableAttributedString()
    case let .Emphasis(children): // *加强 斜体*
        return renderEmphasis(children)
    case .Html:
        print("Warning Html")
        return NSMutableAttributedString()
    case .Image:
        print("Warning Image")
        return NSMutableAttributedString()
    case .LineBreak:
        return NSMutableAttributedString(string: "\n ")
    case let .Link(childrens, _, url): // 遇到链接不继续向下处理
        guard let children = childrens.first else { fatalError("没有名字") }
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSLinkAttributeName: url ?? ""
        ]
        return NSMutableAttributedString(string: children.text ?? url ?? "", attributes: attributes)
    case .SoftBreak:
        return NSMutableAttributedString(string: "\n ")
    case .Strong(let children):
        return renderStrong(children)
    case .Text(let text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
            ]
        return NSMutableAttributedString(string: text + "\n ", attributes: attributes)
    }
}
//
//  Render.swift
//  SwiftMark
//
//  Created by 宋宋 on 5/7/16.
//  Copyright © 2016 DianQK. All rights reserved.
//

import UIKit
import CommonMark

func mdRender(markdown: String) -> NSAttributedString {
    let node = Node(markdown: markdown)
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
    paragraphStyle.firstLineHeadIndent = 20 // 首行缩进
    paragraphStyle.headIndent = 38
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
    result.addAttributes(attributes, range: NSRange(location: 0, length: result.length))
    attributeString.appendAttributedString(result)
    return attributeString
}

func render(items: [[Block]]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for item in items {
        attributedString.appendAttributedString(render(item))
    }
    return attributedString
}

func render(blocks: [Block]) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for block in blocks {
        attributedString.appendAttributedString(render(block))
    }
    return attributedString
}

func render(inlineElements: [InlineElement], level: Int) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for inlineElement in inlineElements {
        attributedString.appendAttributedString(render(inlineElement, level: level))
    }
    return attributedString
}

func render(block: Block) -> NSMutableAttributedString {
    switch block {
    case .BlockQuote(let items):
        print("Block: \(items)")
        return render(items)
    case let .CodeBlock(text, _):
        print("CodeBlock: \(text)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case .Custom(let literal):
        print("Custom: \(literal)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!
        ]
        print("Custom: \(literal)")
        return NSMutableAttributedString(string: literal, attributes: attributes)
    case let .Heading(texts, level):
        print("Heading: \(texts)")
        // TODO: - level
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
    case let .Paragraph(text):
        print("Paragraph: \(text)")
        return render(text, level: 4)
    case .ThematicBreak: // 标题的换行， Section
        // TODO: - type
        return NSMutableAttributedString(string: "-----------\n ")
    }
}

func render(inlineElement: InlineElement, level: Int) -> NSMutableAttributedString {
    let size = CGFloat(25 - level * 2)
    switch inlineElement {
    case let .Code(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: size)!,
            NSForegroundColorAttributeName: UIColor.redColor()
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Custom(literal):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: size)!
        ]
        print("Custom: \(literal)")
        return NSMutableAttributedString(string: literal, attributes: attributes)
    case let .Emphasis(children): // *加强 斜体*
        return render(children, level: 4)
    case let .Html(text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: size)!
        ]
        print("Html: \(text)")
        return NSMutableAttributedString(string: text, attributes: attributes)
    case let .Image(children, title, url):
        let attributes = [
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: size)!
        ]
        print("Image: \(url)")
        return NSMutableAttributedString(string: url!, attributes: attributes)
    case .LineBreak:
        return NSMutableAttributedString(string: "\n ")
    case let .Link(children, title, url):
        // TODO: - children
        // TTTTTDODO: -
        print("Children: \(children)")
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: size)!,
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSLinkAttributeName: url!
        ]
        return NSMutableAttributedString(string: url!, attributes: attributes)
    case .SoftBreak: // TODO: -
        return NSMutableAttributedString(string: "\n ")
    case .Strong(let children):
        // TODO: Strong
        return render(children, level: level)
    case .Text(let text):
        let attributes = [
            NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: size)!,
        ]
        return NSMutableAttributedString(string: text + "\n ", attributes: attributes)
    }
}

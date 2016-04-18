//
//  Syntax.swift
//  ParserCombinator
//
//  Created by aaaron7 on 16/3/16.
//  Copyright © 2016年 wenjin. All rights reserved.
//

import Foundation

indirect enum Markdown {
    /// *斜体*
    case Ita([Markdown])
    /// **加粗**
    case Bold([Markdown])
    /// # 标题
    case Header(Int, [Markdown])
    /// `代码`
    case InlineCode([Markdown])
    /// ```代码块```
    case CodeBlock(String)
    /// [链接](http)
    case Links([Markdown], String)
    /// ~~删除线~~
//    case Strikethrough([Markdown])
    /// Note？？名字是啥来着
    case Refer([Markdown])
    /// Plain
    case Plain(String)
}
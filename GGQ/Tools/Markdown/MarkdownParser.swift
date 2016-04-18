//
//  MarkdownParser.swift
//  SwiftyDown
//
//  Created by aaaron7 on 16/4/13.
//  Copyright © 2016年 aaaron7. All rights reserved.
//

import Foundation
import UIKit

public class MarkdownParser {
	let reserved = "`*#[("

	public init() {
	}

	public func convert(string: String) -> NSAttributedString {
		let result = self.markdowns().p(string)
		if result.count <= 0 {
			return NSAttributedString(string: "Parsing failed")
		} else {
			return render(result[0].0)
		}
	}

	func markdown() -> Parser<Markdown> {
		return refer() +++ ita() +++ bold() +++ inlineCode() +++ header() +++ links() +++ plain()
		+++ newline() +++ fakeNewline() +++ reservedHandler()
	}

	func markdowns() -> Parser<[Markdown]> {
		let m = space(false) >>= { _ in self.markdown() }
		let mm = many1looptemp(m)
		return Parser { str in
			return mm.p(str)
		}
	}
}

extension MarkdownParser {
	private func reservedHandler() -> Parser<Markdown> {
		func pred(c: Character) -> Bool {
			return reserved.characters.indexOf(c) != nil
		}

		return satisfy(pred) >>= { c in
			pure(.Plain(String(c)))
		}
	}

	private func header() -> Parser<Markdown> {
		return newline() >>= { _ in
			many1loop(parserChar("#")) >>= { cs in
				line() >>= { str in
					var tmds: [Markdown] = self.pureStringParse(str)
					tmds.insert(.Plain("\n\n"), atIndex: 0)
					tmds.append(.Plain("\n"))
					return pure(.Header(cs.count, tmds))
				}
			}
		}
	}

	private func ita() -> Parser<Markdown> {
		return pair("*") >>= { str in
			let mds = self.pureStringParse(str)
			return pure(.Ita(mds))
		}
	}

	private func bold() -> Parser<Markdown> {
		return pair("**") >>= { str in
			let mds = self.pureStringParse(str)
			return pure(.Bold(mds))
		}
	}

	private func inlineCode() -> Parser<Markdown> {
		return pair("`") >>= { str in
			let mds = self.pureStringParse(str)
			return pure(.InlineCode(mds))
		}
	}

	private func links() -> Parser<Markdown> {
		return pair("[", sepa2: "]") >>= { str in
			pair("(", sepa2: ")") >>= { str1 in
				let mds = self.pureStringParse(str)
				return pure(.Links(mds, str1))
			}
		}
	}

	private func markdownNewLineBreak() -> Parser<String> {
		let p = trimedSatisfy(isNewLine)
		return p >>= { _ in
			many1loop(p) >>= { _ in
				pure("\n")
			}
		}
	}

	private func newline() -> Parser<Markdown> {
		return markdownNewLineBreak() >>= { str in
			pure(.Plain(str))
		}
	}

	private func fakeNewline() -> Parser<Markdown> {
		return trimedSatisfy(isNewLine) >>= { _ in
			pure(.Plain(" "))
		}
	}

	private func markdownLineStr() -> Parser<String> {
		return Parser { str in
			var result = ""
			var rest = str
			while (true) {
				var temp = lineStr().p(rest)
				guard temp.count > 0 else {
					result.append(rest[rest.startIndex])
					rest = String(rest.characters.dropFirst())
					continue
				}

				result += temp[0].0
				rest = temp[0].1

				let linebreaks = self.markdownNewLineBreak().p(temp[0].1)
				if linebreaks.count > 0 {
					break
				} else {
					continue
				}
			}

			return [(result, rest)]
		}
	}

	private func plain() -> Parser<Markdown> {
		func pred(c: Character) -> Bool {
			if reserved.characters.indexOf(c) != nil {
				return false
			}
			return isNotNewLine(c)
		}

		return many1loop(satisfy(pred)) >>= { cs in
			pure(.Plain(String(cs)))
		}
	}

	private func pureStringParse(string: String) -> [Markdown] {
		let result = self.markdowns().p(string)
		if result.count > 0 {
			return result[0].0
		} else {
			return []
		}
	}

	private func refer() -> Parser<Markdown> {
		return newline() >>= { _ in
			space(false) >>= { _ in
				symbol("> ") >>= { _ in
					self.markdownLineStr() >>= { str in
						let mds = self.pureStringParse(str)
						return pure(.Refer(mds))
					}
				}
			}
		}
	}
}

public enum PalmFont: String {
	case PingFangSCRegular = "PingFangSC-Regular"
	case PingFangSCThin = "PingFangSC-Thin"
	case PingFangSCLight = "PingFangSC-Light"
	case PingFangSCMedium = "PingFangSC-Medium"
}

extension MarkdownParser {
	func render(arr: [Markdown]) -> NSAttributedString {
		return renderHelper(arr, parentAttribute: nil)
	}

	func renderHelper(arr: [Markdown], parentAttribute: [String: AnyObject]?) -> NSAttributedString {
		let attributedString: NSMutableAttributedString = NSMutableAttributedString()

		for m in arr {
			var baseAttribute: [String: AnyObject] = [:]

			if let parentAttribute = parentAttribute {
				for att in parentAttribute {
					baseAttribute[att.0] = att.1
				}
			}

			switch m {
			case .Ita(let mds):
				var tAttr: [String: AnyObject] = baseAttribute

				if tAttr[NSFontAttributeName] != nil {
					let size = tAttr[NSFontAttributeName]!.pointSize
					tAttr[NSFontAttributeName] = UIFont.italicSystemFontOfSize(size)
				} else {
					tAttr[NSFontAttributeName] = UIFont.italicSystemFontOfSize(17)
				}

				let subAttrString = renderHelper(mds, parentAttribute: tAttr)
				attributedString.appendAttributedString(subAttrString)

			case .Bold(let mds):
				var tAttr: [String: AnyObject] = baseAttribute
				if tAttr[NSFontAttributeName] != nil {
					let size = tAttr[NSFontAttributeName]!.pointSize
					tAttr[NSFontAttributeName] = UIFont(name: "PingFangSC-Medium", size: size)!
				} else {
					tAttr[NSFontAttributeName] = UIFont(name: "PingFangSC-Medium", size: 17)!
				}

				let subAttrString = renderHelper(mds, parentAttribute: tAttr)
				attributedString.appendAttributedString(subAttrString)

			case .Header(let level, let mds):
				let fontSize = 18 + (6 - level * 2)
				var tAttr: [String: AnyObject] = baseAttribute
				tAttr[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: CGFloat(fontSize))!

				let subAttrString = renderHelper(mds, parentAttribute: tAttr)
				attributedString.appendAttributedString(subAttrString)

			case .InlineCode(let mds):

				var tAttr: [String: AnyObject] = baseAttribute

				tAttr[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: 17)!
				tAttr[NSBackgroundColorAttributeName] = UIColor.lightGrayColor()

				let subAttrString = renderHelper(mds, parentAttribute: tAttr)

				attributedString.appendAttributedString(subAttrString)

			case .Links(let mds, let links):
				var tAttr: [String: AnyObject] = baseAttribute

				tAttr[NSLinkAttributeName] = links
				tAttr[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
				tAttr[NSForegroundColorAttributeName] = UIColor.blueColor()
				let subAttrString = renderHelper(mds, parentAttribute: tAttr)

				attributedString.appendAttributedString(subAttrString)

			case .Plain(let str):
				if baseAttribute[NSFontAttributeName] == nil {
					baseAttribute[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: 17)!
				}

				attributedString.appendAttributedString(NSAttributedString(string: str, attributes: baseAttribute))

			case .Refer(let mds):
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
				var tAttr: [String: AnyObject] = baseAttribute
				tAttr[NSBackgroundColorAttributeName] = UIColor.lightGrayColor()
				let subAttrString = renderHelper(mds, parentAttribute: tAttr)
				attributedString.appendAttributedString(subAttrString)
			case .CodeBlock(let code):
//                var tAttr: [String: AnyObject] = baseAttribute
				if baseAttribute[NSFontAttributeName] == nil {
					baseAttribute[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: 17)!
				}

				attributedString.appendAttributedString(NSAttributedString(string: code, attributes: baseAttribute))
			}
		}

		return attributedString
	}
}

//
//  ArticleViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift
//import SwiftyDown

final class ArticleViewModel {
	let content = Variable<String>("")

	let elements = Variable<[NSAttributedString]>([])

	let contentAttributedString = Variable<NSAttributedString?>(nil)

	private let range = Variable<String?>(nil)

	let isLoading = Variable(false)

	let disposeBag = DisposeBag()

	private var realmNotificationToken: NotificationToken?

	init(articleInfo: ArticleInfoObject, contentSize: CGSize) {
		content.asObservable().skip(1)
			.observeOn(.Serial(.Background))
			.map { raw -> NSAttributedString in
				let m = MarkdownParser().convert(raw)
				return m
		}
			.map { str in

				let textStorage = NSTextStorage(attributedString: str)

				let textLayout = NSLayoutManager()
				textStorage.addLayoutManager(textLayout)

				let atextContainer1 = NSTextContainer(size: CGSize(width: contentSize.width, height: 9000))
				textLayout.addTextContainer(atextContainer1)

				let textViewHeight1 = textLayout.boundingRectForGlyphRange(NSRange(location: 0, length: str.length), inTextContainer: atextContainer1).size.height

				textLayout.removeTextContainerAtIndex(0)

				let atextContainer2 = NSTextContainer(size: contentSize)
				textLayout.addTextContainer(atextContainer2)

				let textViewHeight2 = textLayout.boundingRectForGlyphRange(NSRange(location: 0, length: str.length), inTextContainer: atextContainer2).size.height

				textLayout.removeTextContainerAtIndex(0)

				let count = Int(textViewHeight1 / textViewHeight2)

				var result: [NSAttributedString] = []
				var realmRanges: [NSRange] = []
				var realmRangesStr = ""
				for _ in 0 ... count {
					let atextContainer3 = NSTextContainer(size: contentSize)
					textLayout.addTextContainer(atextContainer3)

					let range = textLayout.glyphRangeForTextContainer(atextContainer3)
					result.append(str.attributedSubstringFromRange(range))

					realmRanges.append(range)

					realmRangesStr += "|" + NSStringFromRange(range)
				}

				self.elements.value = result // == 先放这里 == 困

				return realmRangesStr
		}.shareReplay(1)
			.bindTo(range)
			.addDisposableTo(disposeBag)

		if let realm = try? Realm() {
			let predicate = NSPredicate(format: "id = %@", argumentArray: [articleInfo.id])
			let articles = realm.objects(ArticleDetailModel).filter(predicate)

			realmNotificationToken = articles.realm?.addNotificationBlock { [weak self] notification, realm in
				if let strongSelf = self, article = articles.first {
					strongSelf.content.value = article.content
					strongSelf.isLoading.value = false
				}
			}
		}

		GGProvider
			.request(GGAPI.ArticleDetail(articleId: articleInfo.id))
			.gg_storeObject(ArticleDetailModel).debug()
			.flatMapLatest { Realm.rx_objectForPrimaryKey(ArticleDetailModel.self, key: articleInfo.id) }
			.filterNil()
			.map { $0.content }
			.bindTo(content)
			.addDisposableTo(disposeBag)
	}
}

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

class ArticleViewModel {

    let content = Variable<String>("")

    let elements = Variable<[NSAttributedString]>([])

    let contentAttributedString = Variable<NSAttributedString?>(nil)

    private let range = Variable<String?>(nil)

    let isLoading = Variable(false)

    let disposeBag = DisposeBag()

    init(articleInfo: ArticleInfoModel, contentSize: CGSize) {

        content.asObservable().skip(1)
            .observeOn(.Serial(.Background))
            .map { content -> NSAttributedString in

//                let r = NSBundle.mainBundle().URLForResource("Article", withExtension: "css")
//                let s = try! String(contentsOfURL: r!) ?? ""
//                let str = s + content
                return try NSAttributedString(data: content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
        }
            .map { str in

                let textStorage = NSTextStorage(attributedString: str)

                let textLayout = NSLayoutManager()
                textStorage.addLayoutManager(textLayout)

                let atextContainer1 = NSTextContainer(size: CGSize(width: contentSize.width, height: 9000))
                textLayout.addTextContainer(atextContainer1)

                let range = NSRange(location: 0, length: str.length)

                let textViewHeight1 = textLayout.boundingRectForGlyphRange(range, inTextContainer: atextContainer1).size.height

                textLayout.removeTextContainerAtIndex(0)

                let atextContainer2 = NSTextContainer(size: contentSize)
                textLayout.addTextContainer(atextContainer2)

                let textViewHeight2 = textLayout.boundingRectForGlyphRange(range, inTextContainer: atextContainer2).size.height

                textLayout.removeTextContainerAtIndex(0)

                let count = Int(textViewHeight1 / textViewHeight2 + 1)

                var result: [NSAttributedString] = []
                var realmRanges: [NSRange] = []
                var realmRangesStr = ""
                for _ in 0 ... count {
                    let atextContainer3 = NSTextContainer(size: contentSize)
                    textLayout.addTextContainer(atextContainer3)

                    let range = textLayout.glyphRangeForTextContainer(atextContainer3)
                    result.append(str.attributedSubstringFromRange(range))
//                    print(range)
//                    range

                    realmRanges.append(range)

                    realmRangesStr += "|" + NSStringFromRange(range)
                }

                self.elements.value = result // == 先放这里 == 困

                return realmRangesStr
        }.shareReplay(1)
//            .observeOn(.Main)
        .bindTo(range)
            .addDisposableTo(disposeBag)

        if let realm = try? Realm() {
            let predicate = NSPredicate(format: "title = %@", articleInfo.title)
            let list = realm.objects(ArticleDetailModel.self).filter(predicate)

            if list.count == 1 {
                content.value = list.first!.content
                return
            }
        }

        GGWebProvider.request(.Article(path: articleInfo.url))
            .storeObject(ArticleDetailModel)
            .flatMap { Void -> Observable<ArticleDetailModel> in
                do {
                    let realm = try Realm()
                    let predicate = NSPredicate(format: "title = %@", articleInfo.title)

                    let list = realm.objects(ArticleDetailModel.self).filter(predicate)
                    let article = list.first!
                    return Observable.just(article)
                } catch let error as NSError {
                    print(error)
                }
                return Observable.empty()
        }.map { $0.content }.bindTo(content).addDisposableTo(disposeBag)
    }
}

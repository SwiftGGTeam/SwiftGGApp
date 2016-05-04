//
//  ArticleManagerViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
//import RxRealm
import SwiftyJSON
//import SwiftyDown
import CocoaMarkdown

final class ArticleManagerViewModel {

    let elements = Variable<[NSAttributedString]>([])

    let isLoading = Variable(true)
    
    /// 文章是否有更新
    let updated = Variable(false)

    let pagerTotal = Variable(0)

    let disposeBag = DisposeBag()

    init(articleInfo: ArticleInfoObject, nextPageTrigger: Driver<Void>, contentSize: CGSize) {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", argumentArray: [articleInfo.id])

        let articleShare = realm.objects(ArticleDetailModel).filter(predicate).asObservable()
            .map { $0.first }.filterNil().shareReplay(1)

        let attributedString = articleShare
        /// 获取 NSAttributedString ，如果有 Cache ，直接拿
        .flatMapLatest { article -> Observable<NSAttributedString> in
            if let cache = article.cacheData {
                return Observable.just(cache)
                    .observeOn(.Serial(.Background))
                    .map { data in
                        let document = CMDocument(data: data, options: .Normalize)
                        let renderer = CMAttributedStringRenderer(document: document, attributes: CMTextAttributes())
                        renderer.registerHTMLElementTransformer(CMHTMLStrikethroughTransformer())
                        renderer.registerHTMLElementTransformer(CMHTMLSuperscriptTransformer())
                        renderer.registerHTMLElementTransformer(CMHTMLUnderlineTransformer())
                        return renderer.render()
                }
            } else {
                return Observable.just(article.content)
                    .observeOn(.Serial(.Background))
                    .map { str in
                        let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
                        let document = CMDocument(data: data, options: .Normalize)
                        let renderer = CMAttributedStringRenderer(document: document, attributes: CMTextAttributes())
                        renderer.registerHTMLElementTransformer(CMHTMLStrikethroughTransformer())
                        renderer.registerHTMLElementTransformer(CMHTMLSuperscriptTransformer())
                        renderer.registerHTMLElementTransformer(CMHTMLUnderlineTransformer())
                        return renderer.render()
                }
            }
        }.observeOn(.Main).shareReplay(1)
        
        Observable.combineLatest(articleShare, attributedString) { (article: $0, str: $1) }
        /// 处理总页数
        .map { article, str in
            if let pagerTotal = article.pagerTotal.value {
                return pagerTotal
            }
            let textStorage = NSTextStorage(attributedString: str)

            let textLayout = NSLayoutManager()
            textStorage.addLayoutManager(textLayout)

            let atextContainer1 = NSTextContainer(size: CGSize(width: contentSize.width, height: CGFloat.max))
            textLayout.addTextContainer(atextContainer1)

            let textViewHeight1 = textLayout.boundingRectForGlyphRange(NSRange(location: 0, length: str.length), inTextContainer: atextContainer1).size.height

            textLayout.removeTextContainerAtIndex(0)

            let atextContainer2 = NSTextContainer(size: contentSize)
            textLayout.addTextContainer(atextContainer2)

            let textViewHeight2 = textLayout.boundingRectForGlyphRange(NSRange(location: 0, length: str.length), inTextContainer: atextContainer2).size.height

            textLayout.removeTextContainerAtIndex(0)

            let count = Int(textViewHeight1 / textViewHeight2) + 1
            
            /// 对总页数进行缓存
            if let realm = articleInfo.realm {
                do {
                    try realm.write {
                        article.pagerTotal.value = count
                    }
                } catch {
                    log.error("Realm write \(articleInfo) : \(error)")
                }
            }
            
            return count
        }
            .bindTo(pagerTotal)
            .addDisposableTo(disposeBag)

        let textLayoutManager = attributedString
            .map { str -> (textStorage: NSTextStorage, textLayout: NSLayoutManager, str: NSAttributedString) in
                let textStorage = NSTextStorage(attributedString: str)

                let textLayout = NSLayoutManager()
                textStorage.addLayoutManager(textLayout)
                log.info("\(str)")
                return (textStorage: textStorage, textLayout: textLayout, str: str)
        }.shareReplay(1)

        Observable.combineLatest(pagerTotal.asObservable(), textLayoutManager) { (count: $0, $1) }
        /// 切分最新的一页
        .map { count, text in
            var atts: [NSAttributedString] = []
            for _ in 0..<count {
                let atextContainer = NSTextContainer(size: contentSize)
                text.textLayout.addTextContainer(atextContainer)
                let range = text.textLayout.glyphRangeForTextContainer(atextContainer)
                atts.append(text.str.attributedSubstringFromRange(range))
            }
            return atts
        }
            .bindTo(elements)
            .addDisposableTo(disposeBag)

        let json = GGProvider
            .request(GGAPI.ArticleDetail(articleId: articleInfo.id))
            .gg_mapJSON()

        let object = Realm.rx_objectForPrimaryKey(ArticleDetailModel.self, key: articleInfo.id)

        Observable.combineLatest(json, object) { (json: $0, object: $1) }.flatMap { json, object -> Observable<Void> in
            if let object = object {
                if json["updateDate"].doubleValue > Double(object.updateDate) {
                    return Realm.rx_create(ArticleDetailModel.self, value: json.object, update: true)
                }
                return Observable.empty()
            } else {
                return Realm.rx_create(ArticleDetailModel.self, value: json.object, update: false)
            }
            }
            .map { true }
            .bindTo(updated)
            .addDisposableTo(disposeBag)
    }

    func contentText(page page: Int) -> Observable<NSAttributedString> {
        return elements.asObservable().filter { $0.count >= page }.map { $0[page - 1] }
    }
}

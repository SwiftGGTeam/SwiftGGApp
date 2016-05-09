//
//  ArticleManagerViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import SwiftyJSON
//import CocoaMarkdown

final class ArticleManagerViewModel {

    let elements = Variable<[NSAttributedString]>([])

    let isLoading = Variable(true)
    
    /// 文章是否有更新
    let updated = Variable(false)

    let pagerTotal = Variable(0)
    
    let currentReadPage: Int

    private let currentPage = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    init(articleInfo: ArticleInfoObject, nextPageTrigger: Driver<Void>, contentSize: CGSize) {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", argumentArray: [articleInfo.id])
        
        let articleObject = realm.objects(ArticleDetailModel).filter(predicate)
        
        if let article = articleObject.first,
            page = article.currentPage.value {
            currentReadPage = page
        } else {
            currentReadPage = 1
        }

        let articleShare = articleObject.asObservable()
            .map { $0.first }.filterNil().shareReplay(1).take(1)
        
        Observable.combineLatest(articleShare, currentPage.asObservable().observeOn(.Main)) { (article: $0, page: $1) }.subscribeNext { article, page in
            if let currentPage = article.currentPage.value where currentPage >= page {
                return
            }
            /// FIXME: - 然而这里的逻辑也要改 tip: viewDidAppear
            guard page >= 1 else { return }
            if let realm = article.realm {
                do {
                    try realm.write {
                        Info("currentPage: \(page - 1)")
                        if page == 1 {
                            article.currentPage.value = page
                        } else {
                            article.currentPage.value = page - 1
                        }
                    }
                } catch {
                    Error("Realm write currentPage \(articleInfo) : \(error)")
                }
            }
        }.addDisposableTo(disposeBag)
        
        if let cacheAttributedStrings = articleCache[articleInfo.id] as? [NSAttributedString] {
            elements.value = cacheAttributedStrings
            pagerTotal.value = cacheAttributedStrings.count
        } else {
            let attributedString = articleShare
                /// 获取 NSAttributedString ，如果有 Cache ，直接拿
                .flatMapLatest { article -> Observable<NSAttributedString> in
                    return Observable.just(article.content)
                        .map { $0
                            .stringByReplacingOccurrencesOfString("<center>", withString: "")
                            .stringByReplacingOccurrencesOfString("</center>", withString: "")
                            .stringByReplacingOccurrencesOfString("http://swift.gg/20", withString: "swiftgg://swift.gg/20")
                        }
                        //                    .map { $0.stringByReplacingOccurrencesOfString("> 本文由 SwiftGG 翻译组翻译，已经获得作者翻译授权，最新文章请访问 [http://swift.gg](http://swift.gg)。", withString: "") }
                        .observeOn(.Serial(.Background))
                        .map { mdRender(markdown: $0) }
                }
                .observeOn(.Main)
                .shareReplay(1)
            
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
                            Error("Realm write \(articleInfo) : \(error)")
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
                    Info("\(str)")
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
            
            elements.asObservable().skip(1).subscribeNext {
                articleCache[articleInfo.id] = $0
                }.addDisposableTo(disposeBag)
        }

        let json = GGProvider
            .request(GGAPI.ArticleDetail(articleId: articleInfo.id))
            .gg_mapJSON()

        let object = Realm.rx_objectForPrimaryKey(ArticleDetailModel.self, key: articleInfo.id)

        Observable.zip(json, object) { (json: $0, object: $1) }.flatMap { json, object -> Observable<Bool> in
            if let object = object {
                if json["updateDate"].doubleValue > Double(object.updateDate) {
                    return Realm.rx_create(ArticleDetailModel.self, value: json.object, update: true).map { true }
                }
                return Observable.empty()
            } else {
                return Realm.rx_create(ArticleDetailModel.self, value: json.object, update: false).map { false }
            }
            }
            .bindTo(updated)
            .addDisposableTo(disposeBag)
        
        updated.asObservable()
            .skip(1)
            .subscribeNext {
                if $0 {
                    articleCache[articleInfo.id] = nil
                }
            }.addDisposableTo(disposeBag)

    }

    func contentText(page page: Int) -> Observable<NSAttributedString> {
        currentPage.onNext(page)
        return elements.asObservable().filter { $0.count >= page }.map { $0[page - 1] }
    }
}

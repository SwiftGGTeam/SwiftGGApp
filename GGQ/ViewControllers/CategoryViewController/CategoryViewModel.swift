//
//  CategoryViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class CategoryViewModel {

	let elements = Variable<[ArticleInfoObject]>([])
    
    let hasNextPage = Variable(true)
    
    private let currentPage = Variable(1)

	let isLoading = Variable(false)
    
    let isRefreshing = Variable(false)

	private let disposeBag = DisposeBag()

	init(refreshTrigger: Observable<Void>, loadMoreTrigger: Observable<Void>, category: CategoryObject) {
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "typeId == %@", argumentArray: [category.id])
        let objects = realm.objects(ArticleInfoObject).filter(predicate).sorted("submitDate", ascending: false).asObservableArray().shareReplay(1)
            
            objects
            .subscribeNext { [unowned self] objects in
                self.elements.value = objects
                self.isLoading.value = false
                self.currentPage.value = self.elements.value.count / GGConfig.Home.pageSize + 1
                if objects.count >= category.sum {
                    self.hasNextPage.value = false
                }
            }.addDisposableTo(disposeBag)
        
        let load = objects
            .take(1)
            .filter { $0.count < category.sum && $0.count < GGConfig.Home.pageSize }
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map { _ in }
        
        let loadMoreRequest = [loadMoreTrigger, load].toObservable().merge()
            .withLatestFrom(currentPage.asObservable())
            .takeUntil(hasNextPage.asObservable().filter { !$0 })
            .shareReplay(1)
        
        let loadMoreResult = loadMoreRequest
            .map { GGAPI.ArticlesByCategory(categoryId: category.id, pageIndex: $0, pageSize: GGConfig.Category.pageSize) }
            .flatMapLatest(GGProvider.request)
            .gg_storeArray(ArticleInfoObject)
            .shareReplay(1)
        
        [loadMoreRequest.map { _ in true }, loadMoreResult.map { false }]
            .toObservable()
            .merge()
            .bindTo(isLoading)
            .addDisposableTo(disposeBag)
        
        let refreshResult = refreshTrigger
            .map { GGAPI.ArticlesByCategory(categoryId: category.id, pageIndex: 1, pageSize: GGConfig.Category.pageSize) }
            .flatMapLatest(GGProvider.request)
            .gg_storeArray(ArticleInfoObject)
        
        [refreshTrigger.map { true }, refreshResult.map { false }]
            .toObservable()
            .merge()
            .bindTo(isRefreshing)
            .addDisposableTo(disposeBag)
	}
}

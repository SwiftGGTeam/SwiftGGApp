//
//  ReadStatusViewModel.swift
//  GGQ
//
//  Created by 宋宋 on 5/10/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ReadStatusViewModel {
    let afterReadElements = Variable<[ArticleInfoObject]>([])
    
    let favoriteElements = Variable<[ArticleInfoObject]>([])
    
    let readingElements = Variable<[ArticleInfoObject]>([])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let realm = try! Realm()
        
        let favoritePredicate = NSPredicate(format: "isFavorite == %@", true)
        realm.objects(ArticleInfoObject)
            .filter(favoritePredicate)
            .asObservableArray()
            .bindTo(favoriteElements)
            .addDisposableTo(disposeBag)
        
        let afterReadPredicate = NSPredicate(format: "readItLater == %@ && hasBeenRead != %@", true, true)
        realm.objects(ArticleInfoObject)
            .filter(afterReadPredicate)
            .asObservableArray()
            .bindTo(afterReadElements)
            .addDisposableTo(disposeBag)
        
        let readingPredicate = NSPredicate(format: "isReading == %@ && hasBeenRead != %@", true, true)
        realm.objects(ArticleInfoObject)
            .filter(readingPredicate)
            .asObservableArray()
            .bindTo(readingElements)
            .addDisposableTo(disposeBag)
    }
}

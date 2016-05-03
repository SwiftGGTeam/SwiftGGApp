//
//  ProfileViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/12.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

class ProfileViewModel {
    
    let avatarURL: Observable<NSURL>
    
    let userName: Observable<String>
    
    let logined: Observable<Bool>
    
    private let tokenSubject = PublishSubject<Token>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let realm = try! Realm()
        
        let optionalUser = realm.objects(UserModel).asObservable()
            .map { $0.first }
            .shareReplay(1)
        
        let updateToken = tokenSubject.asObservable()
        
        let noUser = optionalUser.map { $0 == nil }
        
        [updateToken, noUser.filter { $0 }].toObservable()
            .map { _ in TokenType.GitHub }
            .filter(KeychainService.exist)
            .map { _ in }
            .flatMapLatest { GGProvider.request(GitHubAPI.User).mapJSON() }
            .flatMapLatest { Realm.rx_create(UserModel.self, value: $0.object, update: true) }
            .subscribe()
            .addDisposableTo(disposeBag)
        
        logined = noUser.map { !$0 }
        
        let user = optionalUser.filterNil().shareReplay(1)
            
        avatarURL = user
            /// 只有拿到 User 才发出 avatar_url
            .map { NSURL(string: $0.avatar_url) }
            .filterNil()
            .shareReplay(1)
        
        userName = user.asObservable().map { $0.name }.shareReplay(1)
        
        
    }
    
    func save(type: TokenType, token: Token) {
        KeychainService.save(.GitHub, token: token)
        tokenSubject.onNext(token)
    }
    
}

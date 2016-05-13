//
//  Easy.swift
//  GGQ
//
//  Created by 宋宋 on 5/13/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EasyType {
    associatedtype Element
    var result: EasyResult<Element>{get}
}

struct Easy<Result>: EasyType {
    typealias Element = Result
    let result: EasyResult<Result>
}

enum EasyResult<T> {
    typealias Result = EasyResult<T>
    case Success(T)
    case Failure(ErrorType)
}

extension DriverConvertibleType where Self.E: EasyType {
    func gg_map<R>(selector: Self.E.Element -> EasyResult<R>) -> Driver<Easy<R>> {
        
        let mapSelector: Self.E -> Easy<R> = { e in
            switch e.result {
            case .Success(let success):
                return Easy(result: selector(success))
            case .Failure(let error):
                return Easy(result: EasyResult.Failure(error))
            }
        }
        return self.asDriver().map(mapSelector)
    }
    
    
    func gg_flatMap<R>(selector: Self.E.Element -> Driver<Easy<R>>) -> Driver<Easy<R>> {

        let flatMapSelector: Self.E -> Driver<Easy<R>> = { e in
            switch e.result {
            case .Success(let success):
                return selector(success)
            case .Failure(let error):
                return Driver.just(Easy(result: EasyResult<R>.Failure(error)))
            }
        }
        
        return flatMap(flatMapSelector)
        
    }
    
    func gg_flatMapLatest(selector: Self.E.Element -> Driver<Easy<R>>) -> Driver<Easy<R>> {
        
        let flatMapSelector: Self.E -> Driver<Easy<R>> = { e in
            switch e.result {
            case .Success(let success):
                return selector(success)
            case .Failure(let error):
                return Driver.just(Easy(result: EasyResult<R>.Failure(error)))
            }
        }
        
        return flatMapLatest(flatMapSelector)
    }
    
    func gg_flatMapFirst(selector: Self.E.Element -> Driver<Easy<R>>) -> Driver<Easy<R>> {
        
        let flatMapSelector: Self.E -> Driver<Easy<R>> = { e in
            switch e.result {
            case .Success(let success):
                return selector(success)
            case .Failure(let error):
                return Driver.just(Easy(result: EasyResult<R>.Failure(error)))
            }
        }
        
        return flatMapFirst(flatMapSelector)
    }
    
//    func gg_scan<A>(seed: A, accumulator: (A, Self.E.Element) -> A) -> Driver<A> {
//        scan(<#T##seed: A##A#>, accumulator: <#T##(A, Self.E) -> A#>)
//    }
    
//    reduce
    
    func gg_drive(variable: RxSwift.Variable<Self.E.Element>) -> Disposable {
            return drive(onNext: { e in
                switch e.result {
                case .Success(let data):
                    variable.value = data
                case .Failure(let error):
                    Error("\(error)")
                    break
                }
            })
    }
    
//    public func drive(variable: RxSwift.Variable<Self.E>) -> Disposable
}


extension Driver {
    static func gg_just<T>(result: EasyResult<T>) -> Driver<Easy<T>> {
        return Driver<Easy<T>>.just(Easy(result: result))
    }
}
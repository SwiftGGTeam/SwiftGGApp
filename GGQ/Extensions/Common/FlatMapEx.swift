//
//  FlatMapEx.swift
//  GGQ
//
//  Created by 宋宋 on 5/1/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//



//public protocol OptionalType {
//    associatedtype Wrapped
//    var value: Wrapped? { get }
//}
//
//extension Optional: OptionalType {
//    /// Cast `Optional<Wrapped>` to `Wrapped?`
//    public var value: Wrapped? {
//        return self
//    }
//}

//extension SequenceType where Generator.Element: OptionalType {
//    
//    @warn_unused_result
//    public func filterNil() -> [Generator.Element.Wrapped] {
//        return self.flatMap { $0.value }
//    }
//    
//    @warn_unused_result
//    public func withoutNil() -> [Generator.Element.Wrapped] {
//        return self.flatMap { $0.value }
//    }
//}
//
//  RxRealm.swift
//  RxRealm
//
//  Created by Carlos García on 03/12/15.
//  Copyright © 2015 Carlos García. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

// MARK: - Realm extension that adds a reactive interface to Realm
public extension Realm {

    /**
     Enum that represents a Realm within a thread (used for operations)

     - MainThread:             Operations executed in the Main Thread Realm. Completion called in Main Thread
     - BackgroundThread        Operations executed in a New Background Thread Realm. Completion called in the Main Thread
     - SameThread:             Operations executed in the given Background Thread Realm. Completion called in the same Thread
     */
    public enum RealmThread {
        case MainThread
        case BackgroundThread
        case SameThread(Realm)
    }

    public enum RealmError: ErrorType {
        case WrongThread
        case InvalidRealm
        case InvalidReadThread
    }

    // MARK: - Helpers

    /// Realm save closure
    typealias OperationClosure = (realm: Realm) -> ()

    /**
     Executes the given operation passing the read to the operation block. Once it's completed, the completion closure is called passing error in case something went wrong.

     - parameter thread:         Realm thread to operate on
     - parameter writeOperation: Boolean that will commit a write
     - parameter completion:     Completion closure that can contain an error
     - parameter operation:      Operation closure to save in a given realm
     */
    private static func realmOperationInThread(thread: RealmThread, writeOperation: Bool, completion: RealmError? -> Void, operation: OperationClosure) {
        switch thread {
        case .MainThread:
            if !NSThread.isMainThread() {
                completion(.WrongThread)
            }
            do {
                let realm = try Realm()
                if writeOperation { realm.beginWrite() }
                operation(realm: realm)
                if writeOperation { try realm.commitWrite() }
                completion(nil)
            } catch {
                completion(.InvalidRealm)
            }
        case .BackgroundThread:
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                do {
                    let realm = try Realm()
                    if writeOperation { realm.beginWrite() }
                    operation(realm: realm)
                    if writeOperation { try realm.commitWrite() }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(nil)
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.InvalidRealm)
                    }
                }
            }
        case .SameThread(let realm):
            do {
                if writeOperation { realm.beginWrite() }
                operation(realm: realm)
                if writeOperation { try realm.commitWrite() }
                completion(nil)
            } catch {
                completion(.InvalidRealm)
            }
        }
    }

    /**
     Generates the Observable that executes the given write operation

     - parameter thread:         Realm thread to perform write on
     - parameter writeOperation: Boolean that determines wether the action is written
     - parameter operation:      Operation closure to save in a realm

     - returns: An Observable of Void type
     */
    private static func realmWriteOperationObservable(thread thread: RealmThread, writeOperation: Bool, operation: OperationClosure) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            Realm.realmOperationInThread(thread, writeOperation: writeOperation, completion: { error in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(())
                observer.onCompleted()
                }, operation: operation)
            return NopDisposable.instance
        }
    }

    // MARK: - Creation

    /**
     Add objects to a Realm

     - parameter objects: Objects to be added
     - parameter update:  Boolean that determines whether an object should be forced updated
     - parameter thread:  Thread to execute Realm actions

     - returns: Observable that completes operation
     */
    static func rx_add<S: SequenceType where S.Generator.Element: Object>(objects: S, update: Bool = false, thread: RealmThread = .BackgroundThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.add(objects, update: update)
        }
    }

    /**
     Creates an object in Realm

     - parameter type:   Object type
     - parameter value:  Value to create object on
     - parameter update: Force update?
     - parameter thread: Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_create<T: Object>(type: T.Type, values: [AnyObject] = [], update: Bool = false, thread: RealmThread = .BackgroundThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            for value in values {
                realm.create(type, value: value, update: update)
            }
        }
    }

    /**
     Creates an object in Realm

     - parameter type:   Object type
     - parameter value:  Value to create object on
     - parameter update: Force update?
     - parameter thread: Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_create<T: Object>(type: T.Type, value: AnyObject = [:], update: Bool = false, thread: RealmThread = .BackgroundThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.create(type, value: value, update: update)
        }
    }

    // MARK: - Deletion

    /**
     Deletes an Object from Realm

     - parameter object: Object to be deleted
     - parameter thread: Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_delete(object: Object, thread: RealmThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.delete(object)
        }
    }

    /**
     Deletes Objects from a realm

     - parameter objects: Objects to be deleted
     - parameter thread:  Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_delete<S: SequenceType where S.Generator.Element: Object>(objects: S, thread: RealmThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.delete(objects)
        }
    }

    /**
     Deletes Objects from a Realm

     - parameter objects: List of Objects to delete
     - parameter thread:  Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_delete<T: Object>(objects: List<T>, thread: RealmThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.delete(objects)
        }
    }

    /**
     Deletes Objects from a Realm

     - parameter objects: List of Objects to delete
     - parameter thread:  Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_delete<T: Object>(objects: Results<T>, thread: RealmThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.delete(objects)
        }
    }

    /**
     Deletes all objects from Realm

     - parameter thread: Thread to execute Realm actions

     - returns: Observable that fires the operation
     */
    static func rx_deleteAll(thread: RealmThread) -> Observable<Void> {
        return realmWriteOperationObservable(thread: thread, writeOperation: true) { realm in
            realm.deleteAll()
        }
    }

    // MARK: - Querying

    /**
     Returns objects of the given type

     **Note: This observable has to be subscribed on the Main Thread**

     - parameter type: Object type

     - returns: Observable containing Results for the Type
     */
    static func rx_objects<T: Object>(type: T.Type) -> Observable<RealmSwift.Results<T>> {
        return Observable.create { observer in

            MainScheduler.ensureExecutingOnScheduler()

            do {
                let realm = try Realm()
                observer.onNext(realm.objects(type))
                observer.onCompleted()
            } catch {
                observer.onError(RealmError.InvalidRealm)
            }

            return NopDisposable.instance
        }
    }

    /**
     Returns an Object with a given primary key

     - parameter type: Object type
     - parameter key:  Primary key

     - returns: Observable containing the object associated with `key`
     */
    static func rx_objectForPrimaryKey<T: Object>(type: T.Type, key: AnyObject) -> Observable<T?> {
        return Observable.create { observer in
            MainScheduler.ensureExecutingOnScheduler()

            do {
                let realm = try Realm()
                observer.onNext(realm.objectForPrimaryKey(type, key: key))
                observer.onCompleted()
            } catch {
                observer.onError(RealmError.InvalidRealm)
            }

            return NopDisposable.instance
        }
    }

    // MARK: - Reactive Operators

    /**
     Filter Realm `Object` of a given type with a given predicate

     - parameter predicate: Predicate to filter objects

     - returns: Observable containing filtered results for `Object`
     */
    public func filter<T: Object>(predicate: NSPredicate) -> Observable<Results<T>> -> Observable<Results<T>> {
        return { (observable: Observable<Results<T>>) -> Observable<Results<T>> in
            return observable
                .map { $0.filter(predicate) }
        }
    }

    /**
     Filter Realm `Object` of a given type with a given predicate

     - parameter predicateString: Predicate to filter objects

     - returns: Observable containing filtered results for `Object`
     */
    public func filter<T>(predicateString: String) -> Observable<Results<T>> -> Observable<Results<T>> {
        return { (observable: Observable<Results<T>>) -> Observable<Results<T>> in
            return observable
                .map { $0.filter(predicateString) }
        }
    }

    /**
     Sorts `Results` for a given objects using by using a key in ascending/descending order

     - parameter key:       Key the results should be sorted by
     - parameter ascending: true iff the results sort order is ascending

     - returns: Observable of a sorted `Results` set
     */
    public func sorted<T>(key: String, ascending: Bool = true) -> Observable<Results<T>> -> Observable<Results<T>> {
        return { (observable: Observable<Results<T>>) -> Observable<Results<T>> in
            return observable
                .map { $0.sorted(key, ascending: ascending) }
        }
    }
}

public protocol NotificationEmitter {
    func addNotificationBlock(block: (RealmCollectionChange<Self>) -> ()) -> NotificationToken
}

extension List: NotificationEmitter {}
extension AnyRealmCollection: NotificationEmitter {}
extension Results: NotificationEmitter {}
extension LinkingObjects: NotificationEmitter {}

/**
 `RealmChangeset` is a struct that contains the data about a single realm change set.
 
 It includes the insertions, modifications, and deletions indexes in the data set that the current notification is about.
 */
public struct RealmChangeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]
    
    /// the indexes in the collection that were inserted
    public let inserted: [Int]
    
    /// the indexes in the collection that were modified
    public let updated: [Int]
}

public extension NotificationEmitter where Self: RealmCollectionType {
    
    /**
     Returns an `Observable<Self>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
     - returns: `Observable<Self>`, e.g. when called on `Results<Model>` it will return `Observable<Results<Model>>`, on a `List<User>` it will return `Observable<List<User>>`, etc.
     */
    public func asObservable() -> Observable<Self> {
        return Observable.create {observer in
            let token = self.addNotificationBlock {changeset in
                
                let value: Self
                
                switch changeset {
                case .Initial(let latestValue):
                    value = latestValue
                    
                case .Update(let latestValue, _, _, _):
                    value = latestValue
                    
                case .Error(let error):
                    observer.onError(error)
                    return
                }
                
                observer.onNext(value)
            }
            
            return AnonymousDisposable {
                token.stop()
            }
        }
    }
    
    /**
     Returns an `Observable<Array<Self.Generator.Element>>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
     This method emits an `Array` containing all the realm collection objects, this means they all live in the memory. If you're using this method to observe large collections you might hit memory warnings.
     
     - returns: `Observable<Array<Self.Generator.Element>>`, e.g. when called on `Results<Model>` it will return `Observable<Array<Model>>`, on a `List<User>` it will return `Observable<Array<User>>`, etc.
     */
    public func asObservableArray() -> Observable<Array<Self.Generator.Element>> {
        return asObservable().map { Array($0) }
    }
    
    /**
     Returns an `Observable<(Self, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
     When the observable emits for the first time (if the initial notification is not coalesced with an update) the second tuple value will be `nil`.
     
     Each following emit will include a `RealmChangeset` with the indexes inserted, deleted or modified.
     
     - returns: `Observable<(Self, RealmChangeset?)>`
     */
    public func asObservableChangeset() -> Observable<(Self, RealmChangeset?)> {
        return Observable.create {observer in
            let token = self.addNotificationBlock {changeset in
                
                switch changeset {
                case .Initial(let value):
                    observer.onNext((value, nil))
                case .Update(let value, let deletes, let inserts, let updates):
                    observer.onNext((value, RealmChangeset(deleted: deletes, inserted: inserts, updated: updates)))
                case .Error(let error):
                    observer.onError(error)
                    return
                }
            }
            
            return AnonymousDisposable {
                token.stop()
            }
        }
    }
    
    /**
     Returns an `Observable<(Array<Self.Generator.Element>, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
     This method emits an `Array` containing all the realm collection objects, this means they all live in the memory. If you're using this method to observe large collections you might hit memory warnings.
     
     When the observable emits for the first time (if the initial notification is not coalesced with an update) the second tuple value will be `nil`.
     
     Each following emit will include a `RealmChangeset` with the indexes inserted, deleted or modified.
     
     - returns: `Observable<(Array<Self.Generator.Element>, RealmChangeset?)>`
     */
    public func asObservableArrayChangeset() -> Observable<(Array<Self.Generator.Element>, RealmChangeset?)> {
        return asObservableChangeset().map { (Array($0), $1) }
    }
}
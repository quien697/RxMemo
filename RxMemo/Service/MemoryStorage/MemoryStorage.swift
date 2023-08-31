//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import RxSwift

/// store memos in memory
class MemoryStorage: MemoStorageType {
  private var list = [
    Memo(content: "Hello, MVVM!"),
    Memo(content: "Hello, RxSwift!", insertDate: Date().addingTimeInterval(-20))
  ]
  
  // Subject (Observable, Observer)
  // PublishSubject(no initial value)
  // BehaviorSubject(with a value)
  private lazy var store = BehaviorSubject<[Memo]>(value: list)
  
  @discardableResult
  func createMemo(content: String) -> Observable<Memo> {
    let memo = Memo(content: content)
    list.append(memo)
    store.onNext(list)
    return Observable.just(memo)
  }
  
  @discardableResult
  func listMemo() -> Observable<[Memo]> {
    return store
  }
  
  @discardableResult
  func updateMemo(memo: Memo, content: String) -> Observable<Memo> {
    let updatedMemo = Memo(original: memo, updatedContent: content)
    if let index = list.firstIndex(where: { $0 == memo }) {
      list.remove(at: index)
      list.insert(updatedMemo, at: index)
    }
    store.onNext(list)
    return Observable.just(updatedMemo)
  }
  
  @discardableResult
  func deleteMemo(memo: Memo) -> Observable<Memo> {
    if let index = list.firstIndex(where: { $0 == memo }) {
      list.remove(at: index)
    }
    store.onNext(list)
    return Observable.just(memo)
  }
}

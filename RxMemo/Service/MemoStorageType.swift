//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import RxSwift

// CRUD operations: Create, Read, Update, Delete
protocol MemoStorageType {
  @discardableResult
  func createMemo(content: String) -> Observable<Memo>
  
  @discardableResult
  func listMemo() -> Observable<[Memo]>
  
  @discardableResult
  func updateMemo(memo: Memo, content: String) -> Observable<Memo>
  
  @discardableResult
  func deleteMemo(memo: Memo) -> Observable<Memo>
}

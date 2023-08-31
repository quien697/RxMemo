//
//  Memo.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation

struct Memo: Equatable {
  var content: String
  var insertDate: Date
  var identity: String
  
  init(content: String, insertDate: Date = Date())  {
    self.content = content
    self.insertDate = insertDate
    self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
  }
  
  init(original: Memo, updatedContent: String) {
    self = original
    self.content = updatedContent
  }
}

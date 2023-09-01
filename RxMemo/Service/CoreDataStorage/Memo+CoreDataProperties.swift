//
//  Memo+CoreDataProperties.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//
//

import Foundation
import CoreData

extension Memo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
    return NSFetchRequest<Memo>(entityName: "Memo")
  }
  
  @NSManaged public var identity: String?
  @NSManaged public var content: String?
  @NSManaged public var insertDate: Date?
  
}

extension Memo : Identifiable {
  
}

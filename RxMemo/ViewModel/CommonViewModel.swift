//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import RxSwift
import RxCocoa

/// For all view model need
///  1. initializer with the dependencies (sceneCoordinator, storage)
///  2. properties and methods for binding
class CommonViewModel {
  
  // all scenes are embedded in the nav controller so we need to set the title
  let title: Driver<String> // bind with nav title
  // protocol - easy to change the dependencies
  let sceneCoordinator: SceneCoordinatorType
  let storage: MemoStorageType
  
  init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
    self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
    self.sceneCoordinator = sceneCoordinator
    self.storage = storage
  }
  
}

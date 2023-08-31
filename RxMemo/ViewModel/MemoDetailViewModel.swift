//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
  
  let memo: Memo
  let bag = DisposeBag()
  var contents: BehaviorSubject<[String]>
  
  private var formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "Ca_en")
    f.dateStyle = .medium
    f.timeStyle = .medium
    return f
  }()
  
  init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
    self.memo = memo
    self.contents = BehaviorSubject<[String]>(value: [
      memo.content,
      formatter.string(from: memo.insertDate)
    ])
    super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
  }
  
  func performUpdate(memo: Memo) -> Action<String, Void> {
    return Action { input in
      self.storage.updateMemo(memo: memo, content: input)
        .subscribe(onNext: { updatedMemo in
          self.contents.onNext([
            updatedMemo.content,
            self.formatter.string(from: updatedMemo.insertDate)
          ])
        })
        .disposed(by: self.bag)
      
      return Observable.empty()
    }
  }
  
  func makeEditAction() -> CocoaAction {
    return CocoaAction { _ in
      let composeViewModel = MemoComposeViewModel(
        title: "Edit Memo",
        content: self.memo.content,
        sceneCoordinator: self.sceneCoordinator,
        storage: self.storage,
        saveAction: self.performUpdate(memo: self.memo)
      )
      let composeScene = Scene.compose(composeViewModel)
      
      return self.sceneCoordinator
        .transition(to: composeScene, using: .modal, animated: true)
        .asObservable()
        .map { _ in }
    }
  }
  
  func makeDeleteAction() -> CocoaAction {
    return Action { input in
      self.storage.deleteMemo(memo: self.memo)
      
      return self.sceneCoordinator
        .close(animated: true)
        .asObservable()
        .map { _ in }
    }
  }
  
}

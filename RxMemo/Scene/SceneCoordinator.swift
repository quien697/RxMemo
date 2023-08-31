//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
  var sceneViewController: UIViewController {
    return self.children.first ?? self
  }
}

/// Responsibility: Scene Transition (Window, CurrentVC)
class SceneCoordinator: SceneCoordinatorType {
  private let bag = DisposeBag()
  
  private var window: UIWindow
  private var currentVC: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    self.currentVC = window.rootViewController!
  }
  
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
    let subject = PublishSubject<Void>()
    let target = scene.instantiate()
    
    switch style {
    case .root:
      currentVC = target.sceneViewController
      window.rootViewController = target
      subject.onCompleted()
      
    case .push:
      guard let nav = currentVC.navigationController else {
        subject.onError(TransitionError.navitationControllerMissing)
        break
      }
      
      nav.rx.willShow
        .subscribe(onNext: { [unowned self] evt in
          self.currentVC = evt.viewController.sceneViewController
        })
        .disposed(by: bag)
      
      nav.pushViewController(target, animated: animated)
      currentVC = target.sceneViewController
      subject.onCompleted()
      
    case .modal:
      currentVC.present(target, animated: animated) {
        subject.onCompleted()
      }
      currentVC = target.sceneViewController
    }
    
    return subject.ignoreElements().asCompletable()
  }
  
  func close(animated: Bool) -> RxSwift.Completable {
    return Completable.create { [unowned self] completable in
      if let presentingVC = self.currentVC.presentingViewController {
        self.currentVC.dismiss(animated: animated) {
          self.currentVC = presentingVC.sceneViewController
          completable(.completed)
        }
      } else if let nav = self.currentVC.navigationController {
        if nav.popViewController(animated: animated) == nil {
          completable(.error(TransitionError.cannotPop))
          return Disposables.create()
        }
        self.currentVC = nav.viewControllers.last!
        completable(.completed)
      } else {
        completable(.error(TransitionError.unknown))
      }
      
      return Disposables.create()
    }
  }
}

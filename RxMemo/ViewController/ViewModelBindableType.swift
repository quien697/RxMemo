//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by Quien on 2023-08-31.
//

import Foundation
import UIKit

protocol ViewModelBindableType {
  associatedtype ViewModelTtype
  
  var viewModel: ViewModelTtype! { get set }
  func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
  mutating func bind(viewModel: Self.ViewModelTtype) {
    self.viewModel = viewModel
    loadViewIfNeeded()
    bindViewModel()
  }
}

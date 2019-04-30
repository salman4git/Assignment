//
//  Box.swift
//  Assignment
//
//  Created by Salman on 10/08/2018.
//  Copyright © 2018 Salman. All rights reserved.
//

import Foundation
class Box<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}

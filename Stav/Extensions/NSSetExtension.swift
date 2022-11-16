//
//  NSSetExtension.swift
//  Stav
//
//  Created by Samuel Tóth on 13/11/2022.
//

import SwiftUI

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}

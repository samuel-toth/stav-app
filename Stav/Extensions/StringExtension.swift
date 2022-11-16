//
//  StringExtension.swift
//  Stav
//
//  Created by Samuel Tóth on 15/11/2022.
//

import Foundation
extension String {
    func localized() -> String {
      let localizedString = NSLocalizedString(self, comment: "")
      return localizedString
    }
}

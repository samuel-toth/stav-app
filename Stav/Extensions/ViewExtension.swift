//
//  ViewExtension.swift
//  Stav
//
//  Created by Samuel Tóth on 15/11/2022.
//

import Foundation
import SwiftUI

extension TextField {
    func addNameStyle() -> some View {
        self
            .font(.system(size: 25, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
    }
}

extension Text {
    func valueDisplayStyle() -> some View {
        self
            .font(.title2)
            .lineLimit(1)
            .frame(width: 60, height: 30, alignment: .trailing)
            .truncationMode(.tail)
    }
}

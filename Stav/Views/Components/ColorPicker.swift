//
//  ColorPicker.swift
//  Stav
//
//  Created by Samuel Tóth on 09/11/2022.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var selection: String
    
    var body: some View {
        
        let colors = [
            "AccentColor",
            "picker_blue",
            "picker_brown",
            "picker_gray",
            "picker_green",
            "picker_orange",
            "picker_pink",
            "picker_purple",
            "picker_yellow",
            "picker_red"
        ]
        
        let columns = [
            GridItem(.adaptive(minimum: 50))
        ]
        
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(colors, id: \.self){ color in
                ZStack {
                    Circle()
                        .fill(Color(color))
                        .frame(width: 40, height: 40)
                        .onTapGesture(perform: {
                            selection = color
                        })
                        .padding(5)
                    
                    if selection == color {
                        Circle()
                            .stroke(Color(color), lineWidth: 3)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
    }
}


//struct ColorPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPicker(selection: .constant("picker_blue"))
//    }
//}

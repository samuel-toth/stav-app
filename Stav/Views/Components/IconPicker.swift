//
//  IconPicker.swift
//  Stav
//
//  Created by Samuel Tóth on 09/11/2022.
//

import SwiftUI

struct IconPicker: View {
    
    @Binding var selection: String
    @Binding var selectedColor: String
    
    
    var body: some View {
        
        let icons = [
            "number.circle.fill",
            "pencil.circle.fill",
            "bolt.circle.fill",
            "house.circle.fill",
            "figure.walk.circle.fill",
            "car.circle.fill",
            "person.circle.fill",
            "face.smiling.inverse",
            "eye.circle.fill",
            "sportscourt.circle.fill",
            "trophy.circle.fill",
            "globe.europe.africa.fill",
            "sun.max.circle.fill",
            "list.bullet.circle.fill",
            "power.circle.fill",
            "bag.circle.fill",
            "cart.circle.fill",
            "dollarsign.circle.fill",
            "clock.fill",
            "hourglass.circle.fill",
            "heart.circle.fill",
            "bed.double.circle.fill",
            "pill.circle.fill",
            "exclamationmark.circle.fill"
        ]
        
        let columns = [
            GridItem(.adaptive(minimum: 50))
        ]
        
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(icons, id: \.self){ icon in
                ZStack {
                    Image(systemName: icon)
                        .font(.system(size: 40.0))
                        .foregroundColor(Color(selectedColor))
                        .onTapGesture(perform: {
                            selection = icon
                        })
                        .frame(width: 40, height: 40)
                        .padding(5)

                    if selection == icon {
                        Circle()
                            .stroke(Color(selectedColor), lineWidth: 3)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
    }
}

//struct IconPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        IconPicker(selection: .constant("arrow.up"), selectedColor: .constant("picker_red"))
//    }
//}

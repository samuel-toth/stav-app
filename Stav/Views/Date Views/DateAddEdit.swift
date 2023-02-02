//
//  DateAddEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 23/11/2022.
//

import SwiftUI

struct DateAddEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "calendar.circle.fill"
    @State private var timestamp = Date()
    
    
    
    var date: Datum?
    
    private var isValid: Bool {
        !name.isEmpty && name.count < 16
    }
    
    init(dateToEdit: Datum? = nil ) {
        self.date = dateToEdit
        if let date = date {
            self.name = date.name ?? ""
            self.selectedColor = date.color ?? ""
            self.selectedIcon = date.icon ?? ""
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: selectedIcon)
                            .resizable()
                            .foregroundColor(Color(selectedColor))
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                    }
                    TextField("name", text: $name)
                        .addNameStyle()
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }
                    DatePicker(
                        "onDay",
                        selection: $timestamp,
                        displayedComponents: [.date]
                    )
                    
                }
                .listRowSeparator(.hidden)
                
                
                
                Section {
                    DisclosureGroup("selectColor") {
                        ColorPicker(selection: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                    
                    DisclosureGroup("selectIcon") {
                        IconPicker(selection: $selectedIcon, selectedColor: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("customize")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save", action: addOrUpdateDate)
                        .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("addGame")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let date = date {
                    name = date.name ?? ""
                    selectedColor = date.color ?? "AccentColor"
                    selectedIcon = date.icon ?? "calendar.circle"
                    timestamp = date.timestamp ?? Date()
                }
            }
        }
    }
    
    private func addOrUpdateDate() {
        if isValid {
            withAnimation {
                if (date != nil) {
                    DatumManager.shared.updateDatum(datum: date!, name: name, icon: selectedIcon, color: selectedColor, timestamp: timestamp)
                } else {
                    DatumManager.shared.addDatum(name: name, icon: selectedIcon, color: selectedColor, timestamp: timestamp)
                }
                
                dismiss()
            }
        }
    }
}

struct DateAddEdit_Previews: PreviewProvider {
    static var previews: some View {
        DateAddEdit()
    }
}

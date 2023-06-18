//
//  DateAddEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 23/11/2022.
//

import SwiftUI
import SwiftData

struct DateAddEdit: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "calendar.circle.fill"
    @State private var timestamp = Date()
    
    @Observable var datum: Datum?
    
    private var isValid: Bool {
        !name.isEmpty && name.count < 16
    }
    
    init(dateToEdit: Datum? = nil ) {
        self.datum = dateToEdit
        if let date = datum {
            self.name = date.name 
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
                        .onChange(of: name) { oldValue, newValue in
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
                if let date = datum {
                    name = date.name 
                    selectedColor = date.color ?? "AccentColor"
                    selectedIcon = date.icon ?? "calendar.circle"
                    timestamp = date.timestamp 
                }
            }
        }
    }
    
    private func addOrUpdateDate() {
        if isValid {
            withAnimation {
                if (datum != nil) {
                    datum?.name = name
                    datum?.color = selectedColor
                    datum?.icon = selectedIcon
                  
                    try? modelContext.save()
                } else {
                    let datumToAdd = Datum(name: name, isRepeating: false, repeatCycle: "", timestamp: timestamp)
                    modelContext.insert(datumToAdd)
                    try? modelContext.save()
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

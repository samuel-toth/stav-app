//
//  AddEditCounterf.swift
//  Stav
//
//  Created by Samuel Tóth on 17/11/2022.
//

import SwiftUI
import SwiftData

struct CounterAddEdit: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var value: Int = 0
    @State private var hasGoal: Bool = false
    @State private var hasReminder: Bool = false
    @State private var goalValue: Int?
    @State private var goalDate = Date()
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "number.circle.fill"
    
    @Observable private var counter: Counter?
    
    private var isValid: Bool {
        !name.isEmpty && name.count > 3 && (value <= Int16.max && value >= Int16.min)
        && ( !hasGoal || (hasGoal && (goalValue != nil && goalValue! > value )))
    }
    
    init(counterToEdit: Counter? = nil) {
        self.counter = counterToEdit
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
                    
                    TextField("initialValue", value: $value, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
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
                
                
                Section {
                    Toggle(isOn: $hasGoal) {
                        Text("goal")
                    }
                    
                    if hasGoal {
                        TextField("goalValue", value: $goalValue, format: .number).keyboardType(.numberPad)
                            .disabled(!hasGoal)
                        DatePicker(
                            "goalDate",
                            selection: $goalDate,
                            in: Date().addingTimeInterval(86400)...,
                            displayedComponents: [.date]
                        )
                        .disabled(!hasGoal)
                    }
                    
                } header: {
                    Text("setupGoal")
                }
                
                Section {
                    Toggle(isOn: $hasReminder) {
                        Text("reminder")
                    }
                    
                } header: {
                    Text("setupReminder")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        addOrEditCounter()
                    }
                    .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("addCounter")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let counter = counter {
                    name = counter.name
                    value = counter.value
                    hasGoal = counter.hasGoal
                    hasReminder = counter.hasGoal
                    goalValue = counter.goalValue
                    goalDate = counter.goalDate ?? Date.now
                    selectedColor = counter.color
                    selectedIcon = counter.icon
                }
            }
        }
    }
    
    func addOrEditCounter() {
        if isValid {
            withAnimation {
                if (counter != nil) {
                    counter?.name = name
                    counter?.hasGoal = hasGoal
                    counter?.color = selectedColor
                    counter?.icon = selectedIcon
                    counter?.goalValue = goalValue!
                    counter?.goalDate = goalDate
                } else {
                    let counterToAdd = Counter(name: name, value: value, hasGoal: hasGoal, color: selectedColor, icon: selectedIcon)
                    modelContext.insert(counterToAdd)
                }
                
                try? modelContext.save()
                dismiss()
            }
        }
    }
}



#Preview {
    CounterAddEdit()
}


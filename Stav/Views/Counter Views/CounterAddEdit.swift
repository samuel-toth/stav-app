//
//  AddEditCounterf.swift
//  Stav
//
//  Created by Samuel Tóth on 17/11/2022.
//

import SwiftUI

struct CounterAddEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var value: Int?
    @State private var hasGoal: Bool = false
    @State private var hasReminder: Bool = false
    @State private var goalValue: Int?
    @State private var goalDate = Date()
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "number.circle.fill"
    
    
    private var counter: Counter?
    private var isValid: Bool {
        !name.isEmpty && (value == nil || (value != nil && value! <= Int16.max && value! >= Int16.min))
        && ( !hasGoal || (hasGoal && (goalValue != nil && goalValue! > value ?? 0)))
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
                        .addNameStyle()
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }
                    
                    TextField("initialValue", value: $value, format: .number).keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
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
                    name = counter.wrappedName
                    value = Int(counter.value)
                    hasGoal = counter.hasGoal
                    hasReminder = counter.hasGoal
                    goalValue = Int(counter.goalValue)
                    goalDate = counter.wrappedGoalDate
                    selectedColor = counter.wrappedColor
                    selectedIcon = counter.wrappedIcon
                }
            }
        }
    }
    
    func addOrEditCounter() {
        if isValid {
            withAnimation {
                if (counter != nil) {
                    CounterManager.shared.updateCounter(counter: counter!, name: name, hasGoal: hasGoal, color: selectedColor, icon: selectedIcon, goalValue: goalValue!, goalDate: goalDate)
                } else {
                    CounterManager.shared.addCounter(name: name, value: value ?? 0, hasGoal: hasGoal, color: selectedColor, icon: selectedIcon, goalValue: goalValue, goalDate: goalDate)
                }
                dismiss()
            }
        }
    }
}

struct AddEditCounterf_Previews: PreviewProvider {
    static var previews: some View {
        let previewCounter = CounterManager().createTestData()
        CounterAddEdit(counterToEdit: previewCounter).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.locale, .init(identifier: "sk"))
    }
}

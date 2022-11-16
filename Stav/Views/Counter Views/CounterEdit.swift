//
//  CounterEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 09/11/2022.
//

import SwiftUI

struct CounterEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var counter: Counter

    @State private var name: String
    @State private var hasGoal: Bool
    @State private var hasReminder: Bool = false
    @State private var goalValue: Int
    @State private var selectedColor: String
    @State private var selectedIcon: String
        
    let nameString: LocalizedStringKey = "name"
    let valueString: LocalizedStringKey = "value"
    let selectColorString: LocalizedStringKey = "selectColor"
    let selectIconString: LocalizedStringKey = "selectIcon"
    let customizeString: LocalizedStringKey = "customize"
    let goalString: LocalizedStringKey = "goal"
    let goalValueString: LocalizedStringKey = "goalValue"
    let goalDateString: LocalizedStringKey = "goalDate"
    let setupGoalString: LocalizedStringKey = "setupGoal"
    let reminderString: LocalizedStringKey = "reminder"
    let setupReminderString: LocalizedStringKey = "setupReminder"
    let saveString: LocalizedStringKey = "save"
    let cancelString: LocalizedStringKey = "cancel"
    let addCounterString: LocalizedStringKey = "addCounter"
    
    private var isValid: Bool {
        !name.isEmpty && ( !hasGoal || (hasGoal && goalValue > counter.value ))
    }
    
    init(counter: Counter) {
        self.counter = counter
        self._name = State(initialValue: counter.wrappedName)
        self._hasGoal = State(initialValue: counter.hasGoal)
        self._goalValue = State(initialValue: Int(counter.goalValue))
        self._selectedColor = State(initialValue: counter.wrappedColor)
        self._selectedIcon = State(initialValue: counter.wrappedIcon)
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
                    TextField(nameString, text: $name)
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                }
                .padding(5)
                .listRowSeparator(.hidden)
                
                Section {
                    DisclosureGroup(selectColorString) {
                        ColorPicker(selection: $selectedColor)
                    }
                    .accentColor(Color(selectedColor))
                    .listRowSeparator(.hidden)
                    
                    DisclosureGroup(selectIconString) {
                        IconPicker(selection: $selectedIcon, selectedColor: $selectedColor)
                    }
                    .accentColor(Color(selectedColor))
                    .listRowSeparator(.hidden)
                } header: {
                    Text(customizeString)
                }
                
                // TODO: implement goal
                Section {
                    Toggle(isOn: $hasGoal) {
                        Text(goalString)
                    }
                } header: {
                    Text(setupGoalString)
                }
                
                // TODO: implement reminder
                Section {
                    Toggle(isOn: $hasReminder) {
                        Text(setupReminderString)
                    }
                } header: {
                    Text(setupReminderString)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(saveString) {
                        updateCounter()
                    }
                    .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(cancelString, role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    private func updateCounter() {
        if isValid {
            withAnimation {
                CounterManager.shared.updateCounter(counter: counter, name: name, hasGoal: hasGoal, color: selectedColor, icon: selectedIcon, goalValue: goalValue)
                dismiss()
            }
        }
    }
}


struct CounterEditView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = PersistenceController.preview.container.viewContext
        let newCounter = Counter(context: viewContext)
        newCounter.id = UUID()
        newCounter.name = "Test"
        newCounter.value = 0
        newCounter.createdAt = Date()
        newCounter.modifiedAt = Date()
        newCounter.hasGoal = false
        return CounterEdit(counter: newCounter).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.locale, .init(identifier: "sk"))
    }
}

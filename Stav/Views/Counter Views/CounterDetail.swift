//
//  CounterDetail.swift
//  Stav
//
//  Created by Samuel Tóth on 03/11/2022.
//

import SwiftUI
import CoreData
import Charts

struct CounterDetail: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var counter: Counter
    //@StateObject public var rT: RefreshTimer
    
    @State private var isStatisticsExpanded: Bool = false
    @State private var isHistoryExpanded: Bool = false
    @State private var isChartExpanded: Bool = false
    @State private var showHistorySheet = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    @State private var selectedRange = IntervalRange.daily
    
    @State private var offset = 0
    
    private var historyRecords: [CounterHistoryRecord]
    private var statisticsHandler: StatisticsHandler = StatisticsHandler.shared
    
    
    @State private var selectedNumber = 1


    
    
    init(counter: Counter) {
        self.counter = counter
        
        let request: NSFetchRequest<CounterHistoryRecord> = CounterHistoryRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CounterHistoryRecord.timestamp, ascending: false)]
        request.predicate = NSPredicate(format: "recordCounter == %@", counter)
        
        historyRecords = try! PersistenceController.shared.container.viewContext.fetch(request)
        
        //self._rT = StateObject(wrappedValue: RefreshTimer())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                    Text("\(counter.value)")
                        .font(.system(size:90))
                        .fontWeight(Font.Weight.semibold)
                        .padding([.bottom], 10)
                        .foregroundColor(Color(counter.wrappedColor))
                
                
                
                ZStack {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            CounterManager.shared.updateCounterValue(counter: counter, value: selectedNumber)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 80))
                        }
                        .padding([.leading, .trailing], 40)
                        

                        
                        
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            CounterManager.shared.updateCounterValue(counter: counter, value: -selectedNumber)
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 80))
                        }
                        .padding([.leading, .trailing], 40)
                    }
                    .padding([.bottom], 5)
                    
                    Picker("", selection: $selectedNumber) {
                        ForEach(1...100, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .zIndex(-1)
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    .frame(width: 70, height: 100)
                    .clipped()
                }
                
            
                if counter.hasGoal {
                    VStack {
                        Gauge(value: Double(counter.value), in: 0...Double(counter.goalValue)) {
                        } currentValueLabel: {
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("\(Int(counter.goalValue))")
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(Color(counter.wrappedColor))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        if counter.value < counter.goalValue {
                            Text(counter.goalDate?.localizedTimeRemaining() ?? "")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        } else {
                            Text("goalReached")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                    }
                    .padding(25)
                }
                
                
                Divider()
                
                DisclosureGroup("statistics", isExpanded: $isStatisticsExpanded.animation()) {
                    VStack {
                        if historyRecords.count > 2 {
                            
                            Chart(historyRecords.reversed().suffix(20 + 20*offset)) { record in
                                LineMark(x: .value("date", record.timestamp ?? Date(), unit: .minute), y: .value("value", record.result))
                                //PointMark(x: .value(dateString, record.timestamp ?? Date(), unit: .day), y: .value(valueString, record.result))
                            }
                            .chartXAxis(content: {
                                AxisMarks(values: .automatic) { value in
                                    AxisValueLabel()
                                }
                            })
                            .gesture(DragGesture()
                                .onEnded { value in
                                    let direction = detectDirection(value: value)
                                    if direction == .right && offset > 0 {
                                        offset -= 1
                                    } else if direction == .left && (offset + 1) * 20 < historyRecords.count {
                                        offset += 1
                                    }
                                }
                            )
                            .padding()
                            .frame(height: 200)
                        }
                        
                        ExtractedView(labelText: "lastChange", mainText: counter.wrappedModifiedAt.dateToFormattedDatetime())
                        ExtractedView(labelText: "createdAt", mainText: counter.wrappedCreatedAt.dateToFormattedDate())
                        
                        if counter.hasGoal {
                            ExtractedView(labelText: "goalDate", mainText: counter.wrappedGoalDate.dateToFormattedDate())
                        }
                        
                        Divider()
                        
                        HStack {
                            Spacer()
                            Picker("interval", selection: $selectedRange) {
                                ForEach(IntervalRange.allCases, id: \.self) { interval in
                                    Text(LocalizedStringKey(interval.rawValue))
                                }
                            }
                        }
                        
                        let computedVar = StatisticsHandler.shared.groupHistoryRecordsForInterval(historyRecords: historyRecords, interval: selectedRange)
                        ExtractedView(labelText: "average", mainText: String(format: "%.3f", computedVar.average))
                        ExtractedView(labelText: "minimum", mainText: "\(computedVar.min)")
                        ExtractedView(labelText: "maximum", mainText: "\(computedVar.max)")
                        
                    }
                    .padding(.top, 10)
                }
                .padding([.trailing,.leading], 20)
                
                
                DisclosureGroup("history", isExpanded: $isHistoryExpanded.animation()) {
                    VStack {
                        if historyRecords.count == 0 {
                            Text("noRecords")
                        }
                        ForEach(historyRecords.prefix(5)) { record in
                            HStack {
                                Text(record.wrappedTimestamp.dateToFormattedDatetime() )
                                Spacer()
                                Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                                Divider()
                                Text("\(record.result)")
                                    .fontWeight(.bold)
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                        
                        if historyRecords.count > 5 {
                            Button(action: {
                                showHistorySheet.toggle()
                            }) {
                                Text("allRecords")
                                    .foregroundColor(Color.blue)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding([.trailing,.leading], 20)
                
                VStack {
                    Text("")
                        .alert(isPresented: $showResetAlert) {
                            Alert(
                                title: Text("youSure"),
                                message: Text("resetCounter \(counter.wrappedName)"),
                                primaryButton: .default(
                                    Text("cancel")
                                ),
                                secondaryButton: .destructive(
                                    Text("reset"),
                                    action: {
                                        CounterManager.shared.resetCounter(counter: counter)
                                    }
                                )
                            )
                        }
                    Text("")
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("youSure"),
                                message: Text("deleteCounter \(counter.wrappedName)"),
                                primaryButton: .default(
                                    Text("cancel")
                                ),
                                secondaryButton: .destructive(
                                    Text("delete"),
                                    action: {
                                        viewContext.delete(counter)
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                )
                            )
                        }
                }
            }
        }
        .sheet(isPresented: $showHistorySheet) {
            CounterHistory(counter: counter, historyRecords: historyRecords)
        }
        .sheet(isPresented: $showEditSheet) {
            CounterAddEdit(counterToEdit: counter)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: counter.wrappedIcon)
                        .font(.system(size: 25))
                        .foregroundColor(Color(counter.wrappedColor))
                    Text(counter.wrappedName)
                        .font(.system(size: 25))
                        .fontWeight(Font.Weight.semibold)
                        .foregroundColor(Color(counter.wrappedColor))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    CounterManager.shared.toggleFavourite(counter: counter)
                }) {
                    Image(systemName: counter.isFavourite ? "heart.fill" : "heart")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        showEditSheet.toggle()
                    }) {
                        Label("edit", systemImage: "pencil")
                    }
                    
                    Button(action: {
                        showResetAlert.toggle()
                    }) {
                        Label("reset", systemImage: "arrow.counterclockwise.circle")
                    }
                    Button(role: .destructive, action: {
                        showDeleteAlert.toggle()
                    }) {
                        Label("delete", systemImage: "trash")
                    }
                    
                }
            label: {
                Label("more", systemImage: "ellipsis.circle")
            }
            }
        }
    }
    
    
    
    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }
    
    func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
            return .left
        }
        if value.startLocation.x > value.location.x + 24 {
            return .right
        }
        if value.startLocation.y < value.location.y - 24 {
            return .down
        }
        if value.startLocation.y > value.location.y + 24 {
            return .up
        }
        return .none
    }
}


struct CounterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let counter = CounterManager.shared.createTestData()
        
        return NavigationStack {
            CounterDetail(counter: counter).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environment(\.locale, .init(identifier: "sk"))
            
        }
    }
}


// TODO: to separate file
struct ExtractedView: View {
    
    private var labelText: String
    private var mainText: String
    
    init(labelText: String, mainText: String) {
        self.labelText = labelText
        self.mainText = mainText
    }
    
    var body: some View {
        HStack {
            Text(NSLocalizedString(labelText, comment: ""))
                .foregroundColor(Color(UIColor.secondaryLabel))
            Spacer()
            Text(mainText)
        }
    }
}

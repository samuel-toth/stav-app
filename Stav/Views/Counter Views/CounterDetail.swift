//
//  CounterDetail.swift
//  Stav
//
//  Created by Samuel Tóth on 03/11/2022.
//

import SwiftUI
import SwiftData
import Charts

struct CounterDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Observable var counter: Counter
    
    @State private var isStatisticsExpanded: Bool = false
    @State private var isHistoryExpanded: Bool = false
    @State private var isChartExpanded: Bool = false
    @State private var showHistorySheet = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    @State private var selectedRange = IntervalRange.daily
    @State private var selectedNumber = 1
    @State private var offset = 0
    
    // private var statisticsHandler: StatisticsHandler = StatisticsHandler.shared
            
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                Text("\(counter.value)")
                    .font(.system(size:90))
                    .fontWeight(Font.Weight.semibold)
                    .padding([.bottom], 10)
                    .foregroundColor(Color(counter.color))
                
                
                
                ZStack {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            counter.value += selectedNumber
                            let newHistoryRecord = HistoryRecord(value: selectedNumber, totalValue: counter.value)
                            counter.records.append(newHistoryRecord)
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 80))
                        }
                        .padding([.leading, .trailing], 40)
                        
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            counter.value -= selectedNumber
                            let newHistoryRecord = HistoryRecord(value: -selectedNumber, totalValue: counter.value)
                            counter.records.append(newHistoryRecord)
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
                        Gauge(value: Double(counter.value), in: 0...Double(counter.goalValue ?? 0)) {
                        } currentValueLabel: {
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("\(Int(counter.goalValue ?? 0))")
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(Color(counter.color))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        if counter.value < counter.goalValue ?? 0 {
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
                
                //                DisclosureGroup("statistics", isExpanded: $isStatisticsExpanded.animation()) {
                //                    VStack {
                //                        if historyRecords.count > 2 {
                //
                //                            Chart(historyRecords.reversed().suffix(20 + 20*offset)) { record in
                //                                LineMark(x: .value("date", record.timestamp ?? Date(), unit: .minute), y: .value("value", record.result))
                //                                //PointMark(x: .value(dateString, record.timestamp ?? Date(), unit: .day), y: .value(valueString, record.result))
                //                            }
                //                            .chartXAxis(content: {
                //                                AxisMarks(values: .automatic) { value in
                //                                    AxisValueLabel()
                //                                }
                //                            })
                //                            .gesture(DragGesture()
                //                                .onEnded { value in
                //                                    let direction = detectDirection(value: value)
                //                                    if direction == .right && offset > 0 {
                //                                        offset -= 1
                //                                    } else if direction == .left && (offset + 1) * 20 < historyRecords.count {
                //                                        offset += 1
                //                                    }
                //                                }
                //                            )
                //                            .padding()
                //                            .frame(height: 200)
                //                        }
                //
                //                        ExtractedView(labelText: "lastChange", mainText: counter.modifiedAt.dateToFormattedDatetime())
                //                        ExtractedView(labelText: "createdAt", mainText: counter.createdAt.dateToFormattedDate())
                //
                //                        if counter.hasGoal {
                //                            ExtractedView(labelText: "goalDate", mainText: counter.goalDate!.dateToFormattedDate())
                //                        }
                //
                //                        Divider()
                //
                //                        HStack {
                //                            Spacer()
                //                            Picker("interval", selection: $selectedRange) {
                //                                ForEach(IntervalRange.allCases, id: \.self) { interval in
                //                                    Text(LocalizedStringKey(interval.rawValue))
                //                                }
                //                            }
                //                        }
                //
                //                        let computedVar = StatisticsHandler.shared.groupHistoryRecordsForInterval(historyRecords: historyRecords, interval: selectedRange)
                //                        ExtractedView(labelText: "average", mainText: String(format: "%.3f", computedVar.average))
                //                        ExtractedView(labelText: "minimum", mainText: "\(computedVar.min)")
                //                        ExtractedView(labelText: "maximum", mainText: "\(computedVar.max)")
                //
                //                    }
                //                    .padding(.top, 10)
                //                }
                //                .padding([.trailing,.leading], 20)
                
                
                DisclosureGroup("history", isExpanded: $isHistoryExpanded.animation()) {
                    VStack {
                        if counter.records.isEmpty {
                            Text("noRecords")
                        }
                        ForEach(counter.records.prefix(5)) { record in
                            HStack {
                                Text(record.timestamp.dateToFormattedDatetime() )
                                Spacer()
                                Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                                Divider()
                                Text("\(record.totalValue)")
                                    .fontWeight(.bold)
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                        
                        if counter.records.count > 5 {
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
                                message: Text("resetCounter \(counter.name)"),
                                primaryButton: .default(
                                    Text("cancel")
                                ),
                                secondaryButton: .destructive(
                                    Text("reset"),
                                    action: {
                                        // TODO: Reset counter
                                    }
                                )
                            )
                        }
                    Text("")
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("youSure"),
                                message: Text("deleteCounter \(counter.name)"),
                                primaryButton: .default(
                                    Text("cancel")
                                ),
                                secondaryButton: .destructive(
                                    Text("delete"),
                                    action: {
                                        modelContext.delete(counter)
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                )
                            )
                        }
                }
            }
        }
        .sheet(isPresented: $showHistorySheet) {
            CounterHistory(counter: counter, historyRecords: counter.records)
        }
        .sheet(isPresented: $showEditSheet) {
            CounterAddEdit(counterToEdit: counter)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: counter.icon )
                        .font(.system(size: 25))
                        .foregroundColor(Color(counter.color))
                    Text(counter.name)
                        .font(.system(size: 25))
                        .fontWeight(Font.Weight.semibold)
                        .foregroundColor(Color(counter.color))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    counter.isFavourite.toggle()
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
}


//struct CounterDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let counter = CounterManager.shared.createTestData()
//
//        return NavigationStack {
//            CounterDetail(counter: counter)
//        }
//    }
//}


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

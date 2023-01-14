//
//  JobModifyView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/12/23.
//

import SwiftUI

struct JobModifyView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    
    @State private var rate: String = ""
    
    @State private var estimatedTaxRate: String = ""
    
    @State private var selectedSchedule = Schedule.Weekly
    
    @FocusState private var focuseField: Field?
    
    @State private var job: JobEntity?
    
    @State private var initialized = false
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Job name is required", text: $name)
                            .focused($focuseField, equals: .name)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                selectNextField()
                            }
                    }
                    
                    HStack {
                        Text("Rate")
                        Spacer()
                        TextField("Optional earnings rate per hour", text: $rate)
                            .focused($focuseField, equals: .rate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                selectNextField()
                            }
                    }
                }
                
                Section("Pay Period") {
                    HStack {
                        Text("Schedule")
                        Spacer()
                        Picker("", selection: $selectedSchedule) {
                            ForEach(Schedule.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Estimated tax rate")
                        Spacer()
                        TextField("20", value: $estimatedTaxRate, formatter: formatter)
                            .focused($focuseField, equals: .estimatedTaxRate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                selectNextField()
                            }
                        Text("%")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("New Job")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveJob()
                    } label: {
                        Text("Save")
                            .bold()
                    }
                    .disabled(name.isEmpty)
                    .animation(Animation.linear(duration: 0.1), value: name.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .onAppear {
            initialization()
        }
    }
    
    private func initialization() {
        if !initialized {
            self.focuseField = .name
            self.initialized = true
        }
    }
    
    private func selectNextField() {
        focuseField = focuseField.map {
            Field(rawValue: $0.rawValue + 1) ?? .name
        }
    }
    
    private func saveJob() {
        let job = JobEntity(context: moc)
        job.id = UUID()
        job.name = self.name
        job.rate = Double(self.rate) ?? 0.0
        job.schedule = self.selectedSchedule.rawValue
        job.estimatedTaxRate = NSDecimalNumber(string: self.estimatedTaxRate)
        job.clockedIn = false
        
        try? moc.save(with: .error)
    }
}

struct JobCreateEditView_Previews: PreviewProvider {
    static var previews: some View {
        JobModifyView()
    }
}

extension JobModifyView {
    enum Field: Int, Hashable {
        case name, rate, estimatedTaxRate
    }
    
    enum Schedule: String, CaseIterable, Identifiable {
        case Weekly = "Weekly"
        case EveryTwoWeeks = "Every two weeks"
        case TwicePerMonth = "Twice per month"
        case Monthly = "Monthly"
        case EveryFourWeeks = "Every four weeks"
        var id: String { self.rawValue }
        
        static func parse(_ rawValue: String) -> Schedule? {
            switch rawValue {
            case "Weekly": return .Weekly
            case "Every two weeks": return .EveryTwoWeeks
            case "Twice per month": return .TwicePerMonth
            case "Monthly": return .Monthly
            case "Every four weeks": return .EveryFourWeeks
            default:
                return nil
            }
        }
    }
}

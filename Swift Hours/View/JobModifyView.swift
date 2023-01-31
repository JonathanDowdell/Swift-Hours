//
//  JobModifyView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/12/23.
//

import SwiftUI

struct JobModifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ViewModel()
    
    @FocusState private var focuseField: Field?
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Job name is required", text: $viewModel.name)
                            .focused($focuseField, equals: .name)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                selectNextField()
                            }
                    }
                    
                    HStack {
                        Text("Rate")
                        Spacer()
                        TextField("Optional earnings rate per hour", text: $viewModel.rate)
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
                        Picker("", selection: $viewModel.selectedSchedule) {
                            ForEach(Schedule.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Estimated tax rate")
                        Spacer()
                        TextField("0", text: $viewModel.estimatedTaxRate)
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
                        viewModel.createAndSaveNewJob()
                        dismiss()
                    } label: {
                        Text("Save")
                            .bold()
                    }
                    .disabled(viewModel.name.isEmpty)
                    .animation(Animation.linear(duration: 0.1), value: viewModel.name.isEmpty)
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
    }
    
    private func selectNextField() {
        focuseField = focuseField.map {
            Field(rawValue: $0.rawValue + 1) ?? .name
        }
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

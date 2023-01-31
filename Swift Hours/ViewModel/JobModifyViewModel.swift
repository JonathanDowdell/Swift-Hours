//
//  JobModifyViewModel.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/26/23.
//

import SwiftUI
import Combine
import CoreData

extension JobModifyView {
    class ViewModel: ObservableObject {
        @Published var name: String = ""
        
        @Published var rate: String = ""
        
        @Published var estimatedTaxRate: String = ""
        
        @Published var selectedSchedule = Schedule.Weekly
        
        private var moc: NSManagedObjectContext
        
        init(moc: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
            self.moc = moc
        }
        
        func createAndSaveNewJob() {
            // Parse rate
            Logger.log(rate)
            Logger.log(estimatedTaxRate)
            guard let rate = Double(rate) else {
                print("No Rate")
                return
            }
            guard let taxRate = Double(estimatedTaxRate) else {
                print("No Tax Rate")
                return
            }
            let job = JobEntity(context: self.moc)
            job.name = name
            job.rate = rate
            job.schedule = selectedSchedule.rawValue
            job.estimatedTaxRate = NSDecimalNumber(value: taxRate)
            try? moc.save()
//            let _ = JobStorage.shared.createJob(name: name, rate: rate, schedule: selectedSchedule, taxRate: taxRate, isClockedIn: false)
//            JobStorage.shared.saveJob()
        }
    }
}

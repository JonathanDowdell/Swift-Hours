//
//  JobItemViewModel.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/28/23.
//

import SwiftUI
import CoreData

extension JobItem {
    class ViewModel: ObservableObject {
        
        @Published var isDisclosed = false
        
        @Published var clockedIn = false
        
        var job: JobEntity
        
        private var moc: NSManagedObjectContext
        
        init(
            jobEntity: JobEntity,
            context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
        ) {
            self.moc = context
            self.job = jobEntity
            self.clockedIn = self.job.clockedIn
        }
        
        func clockIn() {
            self.job.clockedIn = true
            self.clockedIn = true
            let workEntity = WorkEntity(context: moc)
            workEntity.rate = job.rate
            workEntity.start = Date()
            workEntity.job = job
    
            job.addToWork(workEntity)
    
            try? moc.save(with: .error)
            
            Logger.log("Logging In - \(job.name ?? "")")
        }
        
        func clockOut() {
            guard let work = job.work else { return }
            let workList: [WorkEntity] = work.toArray().sorted { $0.safeStart > $1.safeStart }

            if let latestWork = workList.first {
                job.clockedIn = false
                clockedIn = false
                isDisclosed = false
                Logger.log(latestWork.end?.description ?? "")
                Logger.log(workList.last?.end?.description ?? "")
                // Remove
                var dateComponents = DateComponents()
                dateComponents.hour = Int.random(in: 1...7)
                latestWork.end = Calendar.current.date(byAdding: dateComponents, to: latestWork.safeStart)
                //latestWork.end = Date()
            }
            
            try? moc.save(with: .error)
            Logger.log("Logging Out - \(job.name ?? "")")
        }
        
        func initialization(_ job: JobEntity) {
            
        }
        
        func clockInJob(_ job: JobEntity) {
            
        }
        
        
        
    }
}

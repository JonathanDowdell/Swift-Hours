//
//  JobStorage.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/23/23.
//

import Foundation
import CoreData
import Combine

class JobStorage: NSObject {
    
    static let shared = JobStorage()
    
    var jobs = CurrentValueSubject<[JobEntity], Never>([])
    
    private let jobFetchController: NSFetchedResultsController<JobEntity>
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        
        let fetchRequest = JobEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        self.jobFetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        self.jobFetchController.delegate = self
        
        do {
            try jobFetchController.performFetch()
            jobs.value = self.jobFetchController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }
    
    func createJob(name: String, rate: Double, schedule: JobModifyView.Schedule, taxRate: Double, isClockedIn: Bool) -> JobEntity {
        let job = JobEntity(context: self.context)
        job.name = name
        job.rate = rate
        job.schedule = schedule.rawValue
        job.estimatedTaxRate = NSDecimalNumber(value: taxRate)
        return job
    }
    
    func saveJob() {
        try? context.save()
    }
    
    func deleteJob(_ job: JobEntity) {
        context.delete(job)
    }
    
}

extension JobStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let jobs = controller.fetchedObjects as? [JobEntity] else { return }
        self.jobs.value = jobs
    }
}

//
//  WorkStorage.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/25/23.
//

import Foundation
import CoreData
import Combine

class WorkStorage: NSObject {
    
    static let shared = WorkStorage()
    
    var work = CurrentValueSubject<[WorkEntity], Never>([])
    
    private let workFetchController: NSFetchedResultsController<WorkEntity>
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        
        let fetchRequest = WorkEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        self.workFetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        self.workFetchController.delegate = self
        
        do {
            try workFetchController.performFetch()
            work.value = self.workFetchController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }
    
}

extension WorkStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let work = controller.fetchedObjects as? [WorkEntity] else { return }
        self.work.value = work
    }
}


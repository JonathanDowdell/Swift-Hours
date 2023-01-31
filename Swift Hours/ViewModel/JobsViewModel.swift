//
//  JobsViewModel.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/25/23.
//

import Foundation
import Combine

extension JobsView {
    class ViewModel: ObservableObject {
        
        @Published var jobs = [JobEntity]()
        
        var clockedInJobs: [JobEntity] {
            let filteredJobs = jobs.filter { $0.clockedIn }
            return filterSearch(of: filteredJobs.sorted { $0.name ?? "A" > $1.name ?? "B" })
        }
        
        var clockedOutJobs: [JobEntity] {
            let filteredJobs = jobs.filter { !$0.clockedIn }
            return filterSearch(of: filteredJobs.sorted { $0.name ?? "A" > $1.name ?? "B" })
        }
        
        @Published var isPresenting = false
        
        @Published var searchText = ""
        
        private var cancellableSet = Set<AnyCancellable>()
        
        init(
            jobPublisher: AnyPublisher<[JobEntity], Never> = JobStorage.shared.jobs.eraseToAnyPublisher()
        ) {
            jobPublisher.sink { [weak self] jobs in
                guard let self = self else { return }
                self.jobs = jobs
            }
            .store(in: &cancellableSet)
        }
        
        private func filterSearch(of jobs: [JobEntity]) -> [JobEntity] {
            guard !searchText.isEmpty else { return jobs }
            return jobs.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
        
        func deleteJob(_ job: JobEntity) {
            JobStorage.shared.deleteJob(job)
            JobStorage.shared.saveJob()
        }
    }
}

//
//  JobsView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct JobsView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @State private var searchText = ""
    
    @State private var isPresenting = false
    
    @FetchRequest(entity: JobEntity.entity(), sortDescriptors: [])
    private var jobs: FetchedResults<JobEntity>
    
    @FetchRequest(entity: WorkEntity.entity(), sortDescriptors: [])
    private var work: FetchedResults<WorkEntity>
    
    private var clockedInJobs: [JobEntity] {
        return filterSearch(of: jobs.filter { $0.clockedIn })
    }
    
    private var clockedOutJobs: [JobEntity] {
        return filterSearch(of: jobs.filter { !$0.clockedIn })
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("On the clock") {
                    ForEach(clockedInJobs, id: \.self) { job in
                        JobItem(job: job)
                            .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            moc.delete(clockedInJobs[index])
                            try? moc.save(with: .error)
                        }
                    }
                }
                
                Section("Off the clock") {
                    ForEach(clockedOutJobs, id: \.self) { job in
                        JobItem(job: job)
                            .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            moc.delete(clockedInJobs[index])
                            try? moc.save(with: .error)
                        }
                    }
                }
            }
            .navigationTitle("Jobs")
            .searchable(text: $searchText)
            .popover(isPresented: $isPresenting) {
                JobModifyView()
            }
            .toolbar {
                Button {
                    isPresenting.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func filterSearch(of jobs: [JobEntity]) -> [JobEntity] {
        guard !searchText.isEmpty else { return jobs }
        return jobs.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}



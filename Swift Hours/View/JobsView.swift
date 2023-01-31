//
//  JobsView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct JobsView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("On the clock") {
                    ForEach(viewModel.clockedInJobs, id: \.self) { job in
                        JobItem(viewModel: .init(jobEntity: job))
                            .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteJob(viewModel.clockedInJobs[index])
                        }
                    }
                }
                
                Section("Off the clock") {
                    ForEach(viewModel.clockedOutJobs, id: \.self) { job in
                        JobItem(viewModel: .init(jobEntity: job))
                            .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteJob(viewModel.clockedOutJobs[index])
                        }
                    }
                }
            }
            .navigationTitle("Jobs")
            .searchable(text: $viewModel.searchText)
            .popover(isPresented: $viewModel.isPresenting) {
                JobModifyView()
            }
            .toolbar {
                Button {
                    viewModel.isPresenting.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func filterSearch(of jobs: [JobEntity]) -> [JobEntity] {
        guard !viewModel.searchText.isEmpty else { return jobs }
        return jobs.filter { $0.name?.localizedCaseInsensitiveContains(viewModel.searchText) ?? false }
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}



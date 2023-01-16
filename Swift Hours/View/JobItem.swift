//
//  JobItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct JobItem: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @State private var isDisclosed = false
    
    @State private var clockedIn = false
    
    private(set) var job: JobEntity
    
    private var clockInNowBtn: some View {
        Button {
            withAnimation {
                clockIn()
            }
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Clock In")
                } icon: {
                    Image(systemName: "play.fill")
                        .foregroundColor(.green)
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var clockOutNowBtn: some View {
        Button {
            withAnimation {
                clockOut()
            }
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Clock Out")
                } icon: {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var startAtBtn: some View {
        Button {
            clockedIn.toggle()
        } label: {
            HStack {
                Spacer()
                Label("Start At", systemImage: "clock.fill")
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var stopAtBtn: some View {
        Button {
            clockedIn.toggle()
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Stop At")
                } icon: {
                    Image(systemName: "clock.fill")
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var addEntryBtn: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Label("Add Entry", systemImage: "plus")
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    
    private var detailsBtn: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Label("Details", systemImage: "info.circle.fill")
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    
    private var actions: some View {
        VStack {
            HStack {
                if clockedIn {
                    clockOutNowBtn
                    
                    stopAtBtn
                } else {
                    clockInNowBtn
                    
                    startAtBtn
                }
                
            }
            
            HStack {
                addEntryBtn
                
                detailsBtn
            }
        }
        .frame(height: isDisclosed ? nil : 0, alignment: .top)
        .animation(.default, value: isDisclosed)
    }
    
    private var content: some View {
        VStack {
            HStack {
                Text(job.name ?? "")
                    .foregroundColor(.primary)
                Spacer()
                Button {
                    print("Details")
                } label: {
                    Image(systemName: "info.circle.fill")
                }
                .foregroundColor(.accentColor)
            }
            .contentShape(Rectangle())
            
            if isDisclosed {
                actions
            }
        }
    }
    
    var body: some View {
        Button {
            isDisclosed.toggle()
        } label: {
            content
        }
        .buttonStyle(.plain)
        .onAppear(perform: initialization)
    }
    
    private func initialization() {
        self.clockedIn = self.job.clockedIn
    }
    
    private func changeJobStatus() {
        job.clockedIn.toggle()
        clockedIn.toggle()
        isDisclosed.toggle()
        try? moc.save(with: .error)
        
        let workEntity = WorkEntity(context: moc)
        workEntity.rate = job.rate
        workEntity.start = Date()
    }
    
    private func clockIn() {
        job.clockedIn = true
        clockedIn = true
        isDisclosed = false
        
        let workEntity = WorkEntity(context: moc)
        workEntity.rate = job.rate
        workEntity.start = Date()
        workEntity.job = job
        
        job.addToWork(workEntity)
        
        try? moc.save(with: .error)
        Logger.log("CLOCKED IN")
    }
    
    private func clockOut() {
        guard let _work = job.work else { return }
        let workList: [WorkEntity] = _work.toArray().sorted { $0.start! > $1.start! }
        
        if let latestWork = workList.first {
            job.clockedIn = false
            clockedIn = false
            isDisclosed = false
            Logger.log(latestWork.end?.description ?? "")
            Logger.log(workList.last?.end?.description ?? "")
            latestWork.end = Date()
            try? moc.save(with: .error)
            
            Logger.log("CLOCKED OUT")
        }
    }
}

struct JobItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
//                JobItem(job: "ICOFT")
//                JobItem(name: "SCR Database")
            }
            .navigationTitle("Job")
        }
    }
}

//
//  EntryItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/14/23.
//

import SwiftUI

struct EntryItem: View {
    
    @State private var value: String = ""
    
    private var workEntry: WorkEntry
    
    init(workEntry: WorkEntry) {
        self.workEntry = workEntry
    }
    
    var body: some View {
        HStack {
            Text(workEntry.job.name ?? "Empty Name")
            
            Spacer()
            
            Text("\(workEntry.work.count)")
                .foregroundColor(.green)
                .padding(.horizontal)
            
            Text(value)
        }
        .onAppear {
            initilizer()
        }
    }
    
    func initilizer() {
        let workTimeSum = workEntry.work.map { $0.safeEnd.timeIntervalSince($0.safeStart) }.reduce(0, +)
        let hoursMinutes = workTimeSum.hourMinute
        if hoursMinutes.hours == 0 {
            if hoursMinutes.minutes < 10 {
                value = "0:0\(hoursMinutes.minutes)"
            } else {
                value = "0:\(hoursMinutes.minutes)"
            }
        } else {
            value = "\(hoursMinutes.hours):\(hoursMinutes.minutes)"
        }
    }
}

struct EntryItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Text("Hello World")
                } label: {
                    EntryItem(workEntry: WorkEntry(job: JobEntity(), work: .init()))
                }
            }
            .navigationTitle("EntryItem")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension TimeInterval {
    var hourMinute: (hours: Int, minutes: Int) {
        let (hr,  minf) = modf(self / 3600)
        return (Int(hr), Int(60 * minf))
    }
}

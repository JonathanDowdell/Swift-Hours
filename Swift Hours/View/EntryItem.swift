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
    
    private var textWidth: Int {
        if value.count >= 6 {
            return 65
        } else {
            return 55
        }
    }
    
    init(workEntry: WorkEntry) {
        self.workEntry = workEntry
    }
    
    var body: some View {
        HStack {
            Text(workEntry.job.name ?? "Empty Name")
            
            Spacer()
            
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text("\(workEntry.work.count)")
                    .foregroundColor(.green)
                
                HStack {
                    Spacer()
                    Text(value)
                }
                .frame(width: CGFloat(textWidth))
            }
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
            if hoursMinutes.minutes < 10 {
                value = "\(hoursMinutes.hours):0\(hoursMinutes.minutes)"
            } else {
                value = "\(hoursMinutes.hours):\(hoursMinutes.minutes)"
            }
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

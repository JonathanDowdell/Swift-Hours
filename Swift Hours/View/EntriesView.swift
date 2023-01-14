//
//  EntriesView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct EntriesView: View {
    
    @FetchRequest(entity: WorkEntity.entity(), sortDescriptors: [])
    private var work: FetchedResults<WorkEntity>
    
    private var workGroupedByYear: [Date: [FetchedResults<WorkEntity>.Element]] {
        let workArray = work.map { $0 }
        let group = workArray.sliced(by: [.year], for: \.safeStart)
        return group
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                
            }
        }
    }
    
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}

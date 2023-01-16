//
//  EntryWeekItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import SwiftUI

struct EntryWeekItem: View {
    
    private(set) var weekWorkEntityDictionary: [Int: [Int: [WorkEntity]]]
    
    var body: some View {
        ForEach(weekWorkEntityDictionary.keys.sorted(by: >), id: \.self) { weekKey in
            if let dayWorkEntityDictionary = weekWorkEntityDictionary[weekKey] {
                EntryDayItem(dayWorkEntityDictionary: dayWorkEntityDictionary)
            }
        }
    }
}

struct EntryWeekItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryWeekItem(weekWorkEntityDictionary: .init())
    }
}

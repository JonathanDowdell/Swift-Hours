//
//  WorkEntry.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/14/23.
//

import Foundation

struct WorkEntry: Hashable {
    let job: JobEntity
    let work: [WorkEntity]
}

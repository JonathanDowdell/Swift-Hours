//
//  WorkEntity+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/13/23.
//

import Foundation

extension WorkEntity {
    var safeStart: Date {
        return self.start ?? Date()
    }
    
    var safeEnd: Date {
        return self.end ?? Date()
    }
}

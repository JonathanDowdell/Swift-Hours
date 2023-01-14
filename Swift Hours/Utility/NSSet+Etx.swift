//
//  NSSet+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/13/23.
//

import Foundation

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

//
//  NSManagedObjectContext+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/13/23.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func save(with logging: LogLevel) throws {
        do {
            try self.save()
        } catch {
            Logger.log(error.localizedDescription, level: logging)
            throw error
        }
    }
}

//
//  Swift_HoursApp.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

@main
struct Swift_HoursApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  MainTabView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            JobsView()
                .tabItem {
                    Label("Jobs", systemImage: "building")
                }
            
            EntriesView()
                .tabItem {
                    Label("Entries", systemImage: "clock")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

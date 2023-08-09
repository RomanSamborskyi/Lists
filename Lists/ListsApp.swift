//
//  ListsApp.swift
//  Lists
//
//  Created by Roman Samborskyi on 05.08.2023.
//

import SwiftUI

@main
struct ListsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

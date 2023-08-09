//
//  ContentView.swift
//  Lists
//
//  Created by Roman Samborskyi on 05.08.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ListsViewModel()
    var body: some View {
        VStack {
            ListsMainView(vm: vm)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


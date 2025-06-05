//
//  ContentView.swift
//  hackspaces
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(0)
            DirectoryView()
                .tabItem {
                    Label("Browse", systemImage: "globe")
                }
                .tag(1)
        }
        .padding()
    }
}

// MARK: - Previews

#Preview {
    ContentView()
}

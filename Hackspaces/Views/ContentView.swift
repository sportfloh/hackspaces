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
      DirectoryView()
        .tabItem {
          Label("Browse", systemImage: "globe")
        }
    }
  }
}


// MARK: - Previews

#Preview {
    ContentView()
}

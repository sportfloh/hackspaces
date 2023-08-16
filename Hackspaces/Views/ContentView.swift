//
//  ContentView.swift
//  hackspaces
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import SwiftUI

struct Hackspace: Hashable, Identifiable{
    var id = UUID()
    var image : String
    var title : String
}

struct HackspaceListView: View {
    
    var hackspaces: [Hackspace]

    var body: some View {
        List(hackspaces) {
            let hackspace = $0
            HStack {
                Image(systemName: hackspace.image)
                Text(hackspace.title)
            }
        }
    }
    init(hackspaces: [Hackspace]) {
        self.hackspaces = hackspaces
    }
}

struct FavoritesView: View {
    let favorites: [Hackspace] = [Hackspace(image: "globe", title: "Setion77")]
    
    var body: some View {
        if favorites.isEmpty {
            Text("nicht gefunden")
        } else {
            HackspaceListView(hackspaces:favorites)
        }
        
    }
}

struct BrowseView: View {
    
    let hackspaces = [
        Hackspace(image: "globe", title: "Setion77"),
        Hackspace(image: "circle.hexagonpath", title: "entropia"),
        Hackspace(image: "globe", title: "x-hain")
    ]
    
    var body: some View {
        HackspaceListView(hackspaces:hackspaces)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, Camp!")
            
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                }.tag(1)
                    BrowseView()
                    .tabItem {
                        Label("Browse", systemImage: "globe")
                }.tag(2)
            }
            .padding()
        }
        .padding()
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  FavoritesView.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//

import SwiftUI

struct FavoritesView: View {
    let favorites: [Hackspace] = [
        Hackspace(title: "Section77", apiUrl: "https://api.section77.de")
    ]

    @State private var selectedHackspace: Hackspace?

    var body: some View {
        VStack {
            if favorites.isEmpty {
                Text("Favorites not found")
            } else {
                HackspaceListView(hackspaces: favorites, onSelectHackspace: { hackspace in
                    self.selectedHackspace = hackspace
                })
            }
        }
    }
}

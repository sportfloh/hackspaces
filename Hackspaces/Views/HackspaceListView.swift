//
//  HackspaceListView.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//
import SwiftUI

struct HackspaceListView: View {
    var hackspaces: [Hackspace]
    var onSelectHackspace: (Hackspace) -> Void
    @State var searchKeyword: String = ""

    var body: some View {
        List(searchResults.sorted { $0.title < $1.title }) { hackspace in
            HStack {
                Button(action: {
                    self.onSelectHackspace(hackspace)
                }, label: {
                    Text(hackspace.title)
                })
            }
        }
        .searchable(text: $searchKeyword, prompt: "Search for Hackspaces")

    }

    var searchResults: [Hackspace] {
        if searchKeyword.isEmpty {
            return hackspaces
        } else {
            return hackspaces.filter { $0.title.lowercased().contains(searchKeyword.lowercased()) }
        }
    }

    init(hackspaces: [Hackspace], onSelectHackspace: @escaping (Hackspace) -> Void) {
        self.hackspaces = hackspaces
        self.onSelectHackspace = onSelectHackspace
    }
}

#Preview {
    DirectoryView()
}

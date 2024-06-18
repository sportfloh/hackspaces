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

    var body: some View {
        List(hackspaces) { hackspace in
            HStack {
                Button(action: {
                    self.onSelectHackspace(hackspace)
                }) {
                    Text(hackspace.title)
                }
            }
        }
    }

    init(hackspaces: [Hackspace], onSelectHackspace: @escaping (Hackspace) -> Void) {
        self.hackspaces = hackspaces
        self.onSelectHackspace = onSelectHackspace
    }
}

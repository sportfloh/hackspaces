//
//  Hackspace.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//
import Foundation

struct Hackspace: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var apiUrl: String
}


//
//  SpaceApiTypes.swift
//  test
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation

struct Location: Codable {
    var address: String
    var lat: Double
    var lon: Double
}

struct SpaceApi: Codable {
    var space: String
    var logo: URL?
    var url: URL
    var location: Location
    var state: SpaceState

    struct SpaceState: Codable {
        var open: Bool
    }
}

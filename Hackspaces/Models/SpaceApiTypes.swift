//
//  SpaceApiTypes.swift
//  test
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation

struct Contact: Codable {
    var email: String?
    var irc: String?
    var mastodon: String?
    var mumble: String?
    var twitter: String?
}

struct Location: Codable {
    var address: String
    var lat: Double
    var lon: Double
}

struct SpaceApi: Codable {
    var space: String
    var ext_ccc: String?
    var logo: URL?
    var url: URL
    var location: Location
    var state: SpaceState
    var contact: Contact

    struct SpaceState: Codable {
        var open: Bool
    }
}

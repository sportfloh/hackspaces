//
//  SpaceApiTypes.swift
//  test
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation

struct Feeds: Codable {
    var type: String
    var url: URL
}

struct Contact: Codable {
    var twitter: String
    var email: String
}

struct Data: Codable {
    var api: String
    var contact: Contact
    var feeds: Feeds
    var issuereportchannels: String
}

struct SpaceApi: Codable {
    var space: String
    var logo: String
}

//
//  SpaceApiTypes.swift
//  test
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation
/*
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
    var url: URL
    var valid: Bool
    var lastSeen: Date
  //  var data: Data
}*/

// MARK: - Welcome
struct SpaceApi: Codable {
    let url: String
    let valid: Bool
    let lastSeen: Int
    let data: DataClass
    let validationResult: ValidationResult

    static let allHackspaces: [SpaceApi] = Bundle.main.decode(file: "spaceapi.json")
    static let sampleHackspace: SpaceApi = allHackspaces[0]
}

// MARK: - DataClass
struct DataClass: Codable {
    let api: String
    let contact: Contact
    let issueReportChannels: [String]
    let location: Location
    let logo: String
    let space: String
    let state: State
    let url: String

    enum CodingKeys: String, CodingKey {
        case api, contact
        case issueReportChannels = "issue_report_channels"
        case location, logo, space, state, url
    }
}

// MARK: - Contact
struct Contact: Codable {
    let email: String
}

// MARK: - Location
struct Location: Codable {
    let address: String
    let lat, lon: Double
}

// MARK: - State
struct State: Codable {
    let lastchange: Int
    let lastchangestr: String
    let stateOpen: Bool

    enum CodingKeys: String, CodingKey {
        case lastchange, lastchangestr
        case stateOpen = "open"
    }
}

// MARK: - ValidationResult
struct ValidationResult: Codable {
    let valid, isHTTPS, httpsForward, reachable: Bool
    let cors, contentType, certValid: Bool

    enum CodingKeys: String, CodingKey {
        case valid
        case isHTTPS = "isHttps"
        case httpsForward, reachable, cors, contentType, certValid
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project!")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project!")
        }

        let decoder = JSONDecoder()

        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project!")
        }

        return loadedData
    }
}

/*
var SpaceApis = [SpaceApi]()

func parse(json: Data) {
    let decoder = JSONDecoder()

    if let jsonSpaceApi = try? decoder.decode(SpaceApi.self, from: json) {
        SpaceApis = jsonSpaceApi
        //tableView.reloadData()
    }
}

override func viewDidLoad() {
    super.viewDidLoad()
    let urlString = "https://api.spaceapi.io"
    
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
        }
    }
}
*/

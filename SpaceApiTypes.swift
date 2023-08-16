//
//  SpaceApiTypes.swift
//  test
//
//  Created by Christian Werner on 15.08.23.
//

import Foundation

struct feeds {
    var type : String
    var url : URL
}

struct contact {
    var twitter : String
    var email : String
    
}

struct Data  {
    var api : String
    var contact : contact
    var feeds : feeds
    var issue_report_channels : String
}

struct SpaceApi {
    var url : URL
    var valid : Bool
    var lastSeen : Date
    var Data : Data
    
    
}

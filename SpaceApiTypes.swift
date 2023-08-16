//
//  SpaceApiTypes.swift
//  test
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation

struct feeds:Codable {
    var type : String
    var url : URL
}

struct contact:Codable {
    var twitter : String
    var email : String
    
}

struct Data:Codable  {
    var api : String
    var contact : contact
    var feeds : feeds
    var issue_report_channels : String
}

struct SpaceApi:Codable {
    var url : URL
    var valid : Bool
    var lastSeen : Date
    var Data : Data
    
    
    
    

    
 
    
}

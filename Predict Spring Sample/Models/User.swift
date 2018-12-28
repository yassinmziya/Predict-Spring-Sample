//
//  User.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation

struct UserData: Codable {
    var data: User
}

struct User: Codable {
    var url: String
    var first_name: String
    var last_name: String
    var id: String
    var counts: Counts
    var image: [String: Image]
    
    struct Counts: Codable {
        var pins: Int
        var following: Int
        var followers: Int
        var boards: Int
    }
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
}

struct UserInterestResponse: Codable {
    var data: [Interest]
}

struct Interest: Codable {
    var id: String
    var name: String
}

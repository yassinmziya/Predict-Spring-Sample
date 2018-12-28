//
//  Pins.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/20/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation

struct PinData: Codable {
    var data: Pin
}

struct UserPinsData: Codable {
    var data: [Pin]
    var page: PagingData
}

struct Pin: Codable {
    var creator: Creator
    var url: String
    var note: String
    var link: String
    var counts: Counts
    var id: String
    var image: [String: Image]
    
    struct Creator: Codable {
        var url: String
        var first_name: String
        var last_name: String
        var id: String
    }
    
    struct Counts: Codable {
        var saves: Int
        var comments: Int
    }
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
}

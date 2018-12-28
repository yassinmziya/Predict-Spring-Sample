//
//  Board.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/20/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation

struct BoardData: Codable {
    var data: Board
}

struct UserBoardsData: Codable {
    var data: [Board]
}

struct BoardPinsData: Codable {
    var data: [Pin]
}

struct Board: Codable {
    var url: String
    var id: String
    var name: String
    var counts: Counts
    var image: [String:Image]
    
    struct Counts: Codable {
        var pins: Int
        var collaborators: Int
        var followers: Int
    }
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
}

//
//  Constants.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/19/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation

struct Pinterest {
    static let appId = "5006508571070848083"
    static let appSecret = "ac8fb07a6c0bd73127a4183ea2b49c8757c88b2394abee4cbe92fdd5c66d5eef"
    static let authUrl = "https://api.pinterest.com/oauth"
    static let scope = "read_public,write_public,read_relationships,write_relationships"
    static let redirectUri = "https://whispering-fjord-94444.herokuapp.com/auth/pinterest/callback"
}

//
//  NetworkManager.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/20/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation
import Alamofire

// MARK:- USEFUL STRUCTS
struct AuthResponse: Codable {
    var access_token: String
    var scope: [String]
    var token_type: String
}

struct APIResponse: Codable {
    var data: [Pin]
    var page: PagingData
}

struct PagingData: Codable {
    var cursor: String?
    var next: String?
}

class NetworkManager {
    // MARK:- CONSTANT VARIABLES
    let baseUrl = "https://api.pinterest.com/v1"
    static let sharedInstantce = NetworkManager()
    var accessToken: String?
    
    // MARK:- PRIVATE INITIALIZER
    private init() {}
    
    // MARK:- AUTHENTICATION
    func getAccessToken(authCode: String, completion: @escaping () -> Void) {
        let reqUrl = "\(baseUrl)/oauth/token?grant_type=authorization_code&client_id=\(Pinterest.appId)&client_secret=\(Pinterest.appSecret)&code=\(authCode)"
        Alamofire.request(reqUrl, method: .post).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let authResponse = try? decoder.decode(AuthResponse.self, from: data) {
                    self.accessToken = authResponse.access_token
                    UserDefaults.standard.set(authResponse.access_token, forKey: "pinterestAccessToken")
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- API METHODS
    func getLoggedInUser(completion: @escaping (User?) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        let reqUrl = "\(baseUrl)/me/?access_token=\(accessToken)&fields=first_name%2Cid%2Clast_name%2Curl%2Ccounts%2Cimage"
        
        Alamofire.request(reqUrl, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                // self.printJSON(data: data)
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(UserData.self, from: data) {
                    completion(user.data)
                } else {
                    print("Couldn't decode user data")
                }
            case .failure(let error):
                print (error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getLoggedInUserBoards(completion: @escaping ([Board]) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        let reqUrl = "\(baseUrl)/me/boards/?access_token=\(accessToken)&fields=id%2Cname%2Curl%2Ccounts%2Cimage"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userBoards = try? decoder.decode(UserBoardsData.self, from: data) {
                    completion(userBoards.data)
                } else {
                    print("Couldn't decode user's boards")
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func getLoggedInUserPins(pagingData: PagingData?, completion: @escaping ([Pin], PagingData?) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        // either api prepared "next" url (pagination) or our constructed one (initial data)
        let reqUrl = pagingData?.next ?? "\(baseUrl)/me/pins/?access_token=\(accessToken)&fields=id%2Clink%2Cnote%2Curl%2Ccreator%2Ccounts%2Cimage"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userPins = try? decoder.decode(UserPinsData.self, from: data) {
                    if let _ = userPins.page.next {
                        completion(userPins.data, userPins.page)
                    } else {
                        completion(userPins.data, nil)
                    }
                } else {
                    print("Couldn't decode user's pins for response:")
                    self.printJSON(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion([], nil)
            }
        }
    }
    
    func searchLoggedInUserPins(query: String, completion: @escaping ([Pin], PagingData?) -> Void) {
        guard let accessToken = accessToken, !query.isEmpty else {
            print("No Access Token and/or Search Term")
            return
        }
        
        let reqUrl = "\(baseUrl)/me/search/pins/?query=\(query)&access_token=\(accessToken)&fields=id%2Clink%2Cnote%2Curl%2Ccounts%2Ccreator%2Cimage"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userPinsData = try? decoder.decode(UserPinsData.self, from: data) {
                    if let _ = userPinsData.page.next {
                        completion(userPinsData.data, userPinsData.page)
                    } else {
                        completion(userPinsData.data, nil)}
                } else {
                    print("could not decode search response json")
                    self.printJSON(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion([], nil)
            }
            
        }
    }
    
    func getLoggedInUserInterests(completion: @escaping ([Interest]) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        let reqUrl = "\(baseUrl)/me/following/interests/?access_token=\(accessToken)&fields=id%2Cname"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userInterestResponse = try? decoder.decode(UserInterestResponse.self, from: data) {
                    completion(userInterestResponse.data)
                } else {
                    print("couldn't decode user interests api response")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getLoggedInUserFollows(getFollowers: Bool, pagingData: PagingData?, completion: @escaping ([User], PagingData?) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        let reqUrl = pagingData?.next ?? "\(baseUrl)/me/\( getFollowers ? "followers" : "following/users" )/?access_token=\(accessToken)&fields=first_name%2Cid%2Clast_name%2Curl%2Ccounts%2Cimage"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let followData = try? decoder.decode(UserFollowsResponse.self, from: data) {
                    if let _ = followData.page.next {
                        completion(followData.data, followData.page)
                    } else {
                        completion(followData.data, nil)
                    }
                } else {
                    print("could not decode follow data")
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion([], nil)
            }
        }
    }
    
    // board metods
    func getPinsForBoard(withId id: String, completion: @escaping ([Pin]) -> Void) {
        guard let accessToken = accessToken else {
            print("No Access Token")
            return
        }
        
        let reqUrl = "\(baseUrl)/boards/\(id)/pins/?access_token=\(accessToken)&fields=id%2Clink%2Cnote%2Curl%2Ccreator%2Ccounts%2Cimage"
        
        Alamofire.request(reqUrl).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let boardPins = try? decoder.decode(BoardPinsData.self, from: data) {
                    completion(boardPins.data)
                } else {
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- HELPER METHODS
    func printJSON(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            print(json)
        }
    }
    
    func logout() {
        self.accessToken = nil
        UserDefaults.standard.removeObject(forKey: "pinterestAccessToken")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LoginViewController()
    }
    
}

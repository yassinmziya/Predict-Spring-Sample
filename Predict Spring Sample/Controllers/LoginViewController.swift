//
//  LoginViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/19/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices
import AuthenticationServices

class LoginViewController: UIViewController {

    var authSession: ASWebAuthenticationSession?
    var followMeButton: UIButton!
    var pinterestLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        pinterestLoginButton = UIButton()
        pinterestLoginButton.setTitle("Login With Pinterest", for: .normal)
        pinterestLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        pinterestLoginButton.setTitleColor(.white, for: .normal)
        pinterestLoginButton.backgroundColor = .pinterestRed
        pinterestLoginButton.layer.cornerRadius = 5
        
        pinterestLoginButton.addTarget(self, action: #selector(getAuthCodeWithPinterestLogin), for: .touchUpInside)
        view.addSubview(pinterestLoginButton)
        
        setupConstraints()
    }
    
    @objc func getAuthCodeWithPinterestLogin() {
        let authUrl = URL(string: "\(Pinterest.authUrl)/?response_type=code&redirect_uri=\(Pinterest.redirectUri)&client_id=\(Pinterest.appId)&scope=\(Pinterest.scope)&state=768uyFys")
        let callbackUrlScheme = "predictspringsample://"
        
        authSession = ASWebAuthenticationSession(url: authUrl!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callback: URL?, error: Error?) in

            // handle auth response
            guard error == nil, let successURL = callback else {
                return
            }

            // handle access granted
            if let authCode = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first {
                NetworkManager.sharedInstantce.getAccessToken(authCode: authCode.value!, completion: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = TabBarController()
                })
                return
            }
            
            // handle access denied
            print("No OAuth Code")
        })

        authSession?.start()
         // present(SFSafariViewController(url: authUrl!), animated: true)
    }
    
    func setupConstraints() {
        pinterestLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(40)
            make.width.equalTo(280)
        }
    }

}

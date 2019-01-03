//
//  ProfileUserDataCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class ProfileUserDataCell: UICollectionViewCell {
    
    static let identifier = "profileUserDataCell"
    
    var logoutButton: UIButton!
    var backButton: UIButton!
    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    
    let profileImageHeight = 70
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout-icon"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        contentView.addSubview(logoutButton)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.isHidden = true
        contentView.addSubview(backButton)
        
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = CGFloat(profileImageHeight/2)
        profileImageView.backgroundColor = UIColor.pinterestRed
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        nameLabel = UILabel()
        nameLabel.text = "--"
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        contentView.addSubview(nameLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutButton)
            make.leading.equalToSuperview().offset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(profileImageHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func logout() {
        NetworkManager.sharedInstantce.logout()
    }
    
}

//
//  UserPreviewCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 1/3/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class UserPreviewCell: UICollectionViewCell {
    
    static let identifier = "userPreviewCell"
    
    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = CGFloat(30)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = UIColor.pinterestRed
        contentView.addSubview(profileImageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.text = "Yassin Mziya"
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
    }
    
}

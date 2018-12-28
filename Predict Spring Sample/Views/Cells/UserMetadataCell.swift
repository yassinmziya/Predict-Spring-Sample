//
//  UserMetadataCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class UserMetadataCell: UICollectionViewCell {
    
    static let identifier = "userMetadataCell"
    
    var countValueLabel: UILabel!
    var countNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        countValueLabel = UILabel()
        countValueLabel.text = "-"
        countValueLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        contentView.addSubview(countValueLabel)
        
        countNameLabel = UILabel()
        countNameLabel.text = "---"
        countNameLabel.font = UIFont.systemFont(ofSize: 17)
        countNameLabel.textColor = .darkGray
        contentView.addSubview(countNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countValueLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        
        countNameLabel.snp.makeConstraints({ make in
            make.centerX.equalTo(countValueLabel)
            make.top.equalTo(countValueLabel.snp.bottom).offset(4)
        })
    }
    
}

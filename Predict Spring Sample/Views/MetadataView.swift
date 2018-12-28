//
//  PinMetadataView.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/27/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class MetadataView: UIView {

    var imageView: UIImageView!
    var countLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = UIColor.clear
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 14)
        countLabel.textColor = .darkGray
        addSubview(countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
    }
}

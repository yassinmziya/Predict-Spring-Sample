//
//  SearchResultsEmptyStateView.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/26/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class NoSearchResultsEmptyStateView: UIView {

    var imageView: UIImageView!
    var messegeLabel: UILabel!
    var retryButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .searchBarGray
        
        imageView = UIImageView(image: UIImage(named: "magnifying-glass"))
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        messegeLabel = UILabel()
        messegeLabel.font = UIFont.systemFont(ofSize: 22)
        messegeLabel.numberOfLines = 3
        messegeLabel.textColor = .darkGray
        messegeLabel.textAlignment = .center
        messegeLabel.text = "No Pins Found"
        addSubview(messegeLabel)
        
        retryButton = UIButton()
        retryButton.setTitle("Try Again", for: .normal)
        retryButton.setTitleColor(.pinterestRed, for: .normal)
        retryButton.layer.borderWidth = 2
        retryButton.layer.cornerRadius = 6
        retryButton.layer.borderColor = UIColor.pinterestRed.cgColor
        addSubview(retryButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.centerY).offset(-20)
            make.height.width.equalTo(100)
        }
        
        messegeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messegeLabel.snp.bottom).offset(12)
            make.centerX.equalTo(messegeLabel)
            make.leading.trailing.equalTo(imageView)
        }
    }

}

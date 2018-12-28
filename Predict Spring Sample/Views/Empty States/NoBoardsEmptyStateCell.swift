//
//  NoBoardsEmptyStateCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/27/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class NoBoardsEmptyStateCell: UICollectionViewCell {
    
    static let identifier = "noBoardsEmptyStateView"
    
    var imageView: UIImageView!
    var messegeLabel: UILabel!
    var refreshButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .searchBarGray
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "collage")
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        messegeLabel = UILabel()
        messegeLabel.font = UIFont.systemFont(ofSize: 22)
        messegeLabel.textColor = .darkGray
        messegeLabel.textAlignment = .center
        messegeLabel.text = "No Boards"
        addSubview(messegeLabel)
        
        refreshButton = UIButton()
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.pinterestRed, for: .normal)
        refreshButton.layer.borderWidth = 2
        refreshButton.layer.cornerRadius = 6
        refreshButton.layer.borderColor = UIColor.pinterestRed.cgColor
        addSubview(refreshButton)
        
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
            make.centerX.leading.trailing.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(messegeLabel.snp.bottom).offset(12)
            make.centerX.equalTo(messegeLabel)
            make.leading.trailing.equalTo(imageView)
        }
    }
    
}

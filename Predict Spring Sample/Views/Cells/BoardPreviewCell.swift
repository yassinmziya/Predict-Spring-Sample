//
//  BoardPreviewCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class BoardPreviewCell: UICollectionViewCell {
    
    static let identifier = "boardPreviewCell"
    
    var transparentView = UIView()
    var imageView: UIImageView!
    var boardNameLabel: UILabel!
    var boardCountsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .pinterestRed
        
        imageView = UIImageView()
        imageView.layer.backgroundColor = UIColor.pinterestRed.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        contentView.addSubview(imageView)
        
        boardNameLabel = UILabel()
        boardNameLabel.text = "Board Name"
        boardNameLabel.textColor = .white
        boardNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        transparentView.addSubview(boardNameLabel)
        
        transparentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.addSubview(transparentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       transparentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        boardNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.leading.equalTo(boardNameLabel)
            make.top.equalToSuperview().offset(20)
        }
        
        
    }
    
}

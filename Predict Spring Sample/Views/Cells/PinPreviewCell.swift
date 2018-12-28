//
//  PinPreviewCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class PinPreviewCell: UICollectionViewCell {
    
    static let identifier = "pinPreviewCell"
    
    var imageView: UIImageView!
    var noteLabel: UILabel!
    var showNoteLabel = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .pinterestRed
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        noteLabel = UILabel()
        noteLabel.backgroundColor = .white
        noteLabel.numberOfLines = 2
        noteLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        noteLabel.textColor = .darkGray
        contentView.addSubview(noteLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        noteLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(noteLabel.snp.top)
        }
        
    }
    
}

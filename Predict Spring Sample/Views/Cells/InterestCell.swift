//
//  InterestCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/24/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
 
    static let identifier = "interestCollectionViewCell"
    
    var interestLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            if isSelected {
                interestLabel.backgroundColor = .searchBarGray
                interestLabel.textColor = .darkGray
            } else {
                interestLabel.backgroundColor = .white
                interestLabel.textColor = .lightGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        interestLabel = UILabel()
        interestLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        interestLabel.layer.cornerRadius = CGFloat(15)
        interestLabel.textColor = .lightGray
        interestLabel.textAlignment = .center
        interestLabel.clipsToBounds = true
        contentView.addSubview(interestLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        interestLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

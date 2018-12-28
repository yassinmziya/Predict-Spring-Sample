//
//  LoadingView.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/27/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .searchBarGray
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

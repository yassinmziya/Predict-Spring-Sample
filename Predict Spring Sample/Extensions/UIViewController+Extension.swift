//
//  UIViewController+Extension.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        
        DispatchQueue.main.async {
            self.addChild(child)
            view.addSubview(child.view)
            child.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            child.didMove(toParent: self)
        }
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        DispatchQueue.main.async {
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}

//
//  ProfileUserCountsCell.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

enum UserCountLabel: String {
    case following = "following"
    case followers = "followers"
    case pins = "pins"
    case boards = "boards"
}

class ProfileUserCountsCell: UICollectionViewCell {
    
    static let identifier = "profileUserCountsCell"
    
    var collectionView: UICollectionView!
    let userCountLabels: [UserCountLabel] = [.following, .followers, .pins, .boards]
    var userCounts: (User.Counts)? = nil {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UserMetadataCell.self, forCellWithReuseIdentifier: UserMetadataCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProfileUserCountsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserMetadataCell.identifier, for: indexPath) as! UserMetadataCell
        cell.countNameLabel.text = userCountLabels[indexPath.row].rawValue
        if let userCounts = userCounts {
            switch userCountLabels[indexPath.row] {
            case .followers:
                cell.countValueLabel.text = String(userCounts.followers)
            case .following:
                cell.countValueLabel.text = String(userCounts.following)
            case .pins:
                cell.countValueLabel.text = String(userCounts.pins)
            case .boards:
                cell.countValueLabel.text = String(userCounts.boards)
            }
        }
        
        cell.setNeedsLayout()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCountLabels.count
    }
    
}

extension ProfileUserCountsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (contentView.frame.width)/4, height: contentView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//
//  UsersViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 1/3/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class UsersViewController: UIViewController {
    
    var users: [User] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var followers = true
    var pagingData: PagingData? = nil
    var reloadingOnScrollBottom = false
    
    var backButton: UIButton!
    var titleLabel: UILabel!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = followers ? "Followers" : "Following"
        titleLabel.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        titleLabel.textColor = .lightGray
        view.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserPreviewCell.self, forCellWithReuseIdentifier: UserPreviewCell.identifier)
        view.addSubview(collectionView)
        
        setupConstraints()
        getInitData()
    }
    
    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(14)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func getInitData() {
        NetworkManager.sharedInstantce.getLoggedInUserFollows(getFollowers: followers, pagingData: nil) { (users, pagingData) in
            DispatchQueue.main.async {
                self.users = users
                self.pagingData = pagingData
            }
        }
    }
    
    func getMoreUsers() {
        guard let pagingData = pagingData else { return }
        
        NetworkManager.sharedInstantce.getLoggedInUserFollows(getFollowers: followers, pagingData: pagingData) { (users, pagingData) in
            DispatchQueue.main.async {
                self.users.append(contentsOf: users)
                self.pagingData = pagingData
                self.reloadingOnScrollBottom = false
            }
        }
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension UsersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileVC = ProfileViewController()
        profileVC.user = users[indexPath.row]
        profileVC.isLoggedInUser = false
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPreviewCell.identifier, for: indexPath) as! UserPreviewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.first_name + " " + user.last_name
        let imageResource = ImageResource(downloadURL: URL(string: user.image["60x60"]!.url)!, cacheKey: user.image["60x60"]!.url)
        cell.profileImageView.kf.setImage(with: imageResource)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
}

extension UsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2) - (15 + 5), height: view.frame.width/3)
    }
}

// MARK:- UIScrollViewDelegate
extension UsersViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("did scroll")
        let bottomEdge: CGFloat = collectionView.contentOffset.y + collectionView.frame.height
        if(bottomEdge >= collectionView.contentSize.height) {
            if !reloadingOnScrollBottom {
                print("getting more users")
                reloadingOnScrollBottom = true
                getMoreUsers()
            }
            print("bottom reached")
        }
    }
    
}

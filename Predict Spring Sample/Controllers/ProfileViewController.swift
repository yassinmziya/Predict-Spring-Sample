//
//  ProfileViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

enum ProfileVCSections {
    case userData
    case userCounts
    case userContent
}

class ProfileViewController: UIViewController {

    let sections: [ProfileVCSections] = [.userData, .userCounts, .userContent]
    var mainCollectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var loadingView: LoadingView!
    
    var user: User? = nil {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    var boards: [Board] = [] {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainCVLayout = UICollectionViewFlowLayout()
        mainCVLayout.scrollDirection = .vertical
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mainCVLayout)
        mainCollectionView.backgroundColor = .white
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(ProfileUserDataCell.self, forCellWithReuseIdentifier: ProfileUserDataCell.identifier)
        mainCollectionView.register(ProfileUserCountsCell.self, forCellWithReuseIdentifier: ProfileUserCountsCell.identifier)
        mainCollectionView.register(BoardPreviewCell.self, forCellWithReuseIdentifier: BoardPreviewCell.identifier)
        mainCollectionView.register(NoBoardsEmptyStateCell.self, forCellWithReuseIdentifier: NoBoardsEmptyStateCell.identifier)
        view.addSubview(mainCollectionView)
        
        refreshControl = UIRefreshControl()
        mainCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getInitData), for: .valueChanged)
        view.addSubview(mainCollectionView)
        
        loadingView = LoadingView()
        loadingView.backgroundColor = .white
        view.addSubview(loadingView)
        
        getInitData()
        setupConstraints()
    }
    
    // MARK:- HELPERS
    func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(mainCollectionView)
        }
    }
    
    @objc func getInitData() {
        // get logged in user
        NetworkManager.sharedInstantce.getLoggedInUser { user in
            // get boards
            NetworkManager.sharedInstantce.getLoggedInUserBoards { boards in
                DispatchQueue.main.async {
                    self.boards = boards
                    self.user = user
                    self.loadingView.removeFromSuperview()
                }
            }
        }
        refreshControl.endRefreshing()
    }
    
    @objc func refreshButtonPressed() {
        NetworkManager.sharedInstantce.getLoggedInUserBoards { boards in
            DispatchQueue.main.async {
                self.boards = boards
            }
        }
    }

}

// MARK:- UICollectionViewDataSource and UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .userContent:
            if boards.isEmpty { return }
            
            let board = boards[indexPath.row]
            let boardVC = BoardViewController()
            boardVC.board = board
            navigationController?.pushViewController(boardVC, animated: true)
        default:
            return
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections[section] == .userContent && !boards.isEmpty{
            return boards.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .userData:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileUserDataCell.identifier, for: indexPath) as! ProfileUserDataCell
            if let user = user {
                let imageResource = ImageResource(downloadURL: URL(string: user.image["60x60"]!.url)!, cacheKey: user.image["60x60"]!.url)
                cell.profileImageView.kf.setImage(with: imageResource)
                cell.nameLabel.text = user.first_name + " " + user.last_name
            }
            cell.setNeedsUpdateConstraints()
            return cell
        case .userCounts:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileUserCountsCell.identifier, for: indexPath) as! ProfileUserCountsCell
            if let user = user {
                cell.userCounts = user.counts
            }
            cell.setNeedsUpdateConstraints()
            return cell
        case .userContent:
            if boards.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoBoardsEmptyStateCell.identifier, for: indexPath) as! NoBoardsEmptyStateCell
                cell.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardPreviewCell.identifier, for: indexPath) as! BoardPreviewCell
            let board = boards[indexPath.row]
            let imageResource = ImageResource(downloadURL: URL(string: board.image["60x60"]!.url)!, cacheKey: board.image["60x60"]!.url)
            cell.imageView.kf.setImage(with: imageResource)
            cell.boardNameLabel.text = board.name
            // cell.boardCountsLabel.text = String(board.counts.pins) + " pins"
            cell.setNeedsUpdateConstraints()
            return cell
        }
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .userData:
            return CGSize(width: view.frame.width, height: 240)
        case .userCounts:
           return CGSize(width: view.frame.width, height: 70)
        case .userContent:
            
            return !boards.isEmpty ? CGSize(width: view.frame.width - 30, height: view.frame.height/4) : CGSize(width: view.frame.width, height: view.frame.height - (250 + 80))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .userContent:
            return  UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

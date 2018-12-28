//
//  SearchViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/24/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchViewControllerDelegate {
    func interestCellSelected(query:String)
}

class SearchViewController: UIViewController {

    var delegate: SearchViewControllerDelegate?
    
    var interests: [Interest] = [] {
        didSet {
            interestsCollectionView.reloadData()
        }
    }
    var suggestedBoards: [Board]!
    
    var interestsLabel: UILabel!
    var interestsCollectionView: UICollectionView!
    var noResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interestsLabel = UILabel()
        interestsLabel.text = "My Intersests"
        interestsLabel.textColor = .darkGray
        interestsLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        view.addSubview(interestsLabel)
        
        let interestslayout = UICollectionViewFlowLayout()
        interestslayout.scrollDirection = .horizontal
        interestslayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        interestsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: interestslayout)
        interestsCollectionView.backgroundColor = .white
        interestsCollectionView.showsHorizontalScrollIndicator = false
        interestsCollectionView.dataSource = self
        interestsCollectionView.delegate = self
        interestsCollectionView.register(InterestCell.self, forCellWithReuseIdentifier: InterestCell.identifier)
        view.addSubview(interestsCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        interestsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(24)
        }
        
        interestsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(interestsLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case interestsCollectionView:
            if let delegate = delegate {
                delegate.interestCellSelected(query: interests[indexPath.row].name)
            }
        default:
            print("collection view not setup")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case interestsCollectionView:
            return interests.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = interestsCollectionView.dequeueReusableCell(withReuseIdentifier: InterestCell.identifier, for: indexPath) as! InterestCell
        cell.interestLabel.text = interests[indexPath.row].name
        return cell
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = max(interests[indexPath.row].name.count, 5)
        return CGSize(width: 100, height: 30)
    }
    
}

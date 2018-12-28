//
//  BoardViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

enum BoardVCSections {
    case header
    case pins
}

class BoardViewController: UIViewController {
    
    let sections: [BoardVCSections] = [.header, .pins]
    
    var backButton: UIButton!
    var boardNameLabel: UILabel!
    var numberOfPinsLabel: UILabel!
    var collectionView: UICollectionView!
    
    var board: Board!
    var pins: [Pin] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        boardNameLabel = UILabel()
        boardNameLabel.textColor = .darkGray
        boardNameLabel.text = board.name
        boardNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.addSubview(boardNameLabel)
        
        numberOfPinsLabel = UILabel()
        numberOfPinsLabel.textColor = .lightGray
        numberOfPinsLabel.text = String(board.counts.pins) + " pins"
        numberOfPinsLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(numberOfPinsLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PinPreviewCell.self, forCellWithReuseIdentifier: PinPreviewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        getData()
        setupConstraints()
    }
    
    func setupConstraints() {
        boardNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(100)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(15)
        }
        
        numberOfPinsLabel.snp.makeConstraints { make in
            make.leading.equalTo(boardNameLabel)
            make.top.equalTo(boardNameLabel.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(numberOfPinsLabel.snp.bottom).offset(24)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func getData() {
        NetworkManager.sharedInstantce.getPinsForBoard(withId: board.id) { pins in
            DispatchQueue.main.async {
                self.pins = pins
            }
        }
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pin = pins[indexPath.row]
        let pinVC = PinViewController()
        pinVC.pin = pin
        navigationController?.pushViewController(pinVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinPreviewCell.identifier, for: indexPath) as! PinPreviewCell
        let pin = pins[indexPath.row]
        cell.noteLabel.text = pin.note
        let imageResource = ImageResource(downloadURL: URL(string: pin.image["original"]!.url)!, cacheKey: pin.image["original"]!.url)
        cell.imageView.kf.setImage(with: imageResource)
        return cell
    }
    
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2) - (15 + 6), height: view.frame.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

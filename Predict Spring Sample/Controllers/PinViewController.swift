//
//  PinViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices
import Kingfisher

class PinViewController: UIViewController {
    
    var pin: Pin!
    
    var imageView: UIImageView!
    var backButton: UIButton!
    var noteLabel: UILabel!
    var authorLabel: UILabel!
    var openPinterestUrlButton: UIButton!
    var openLinkButton: UIButton!
    
    var commentMetadataView: MetadataView!
    var savesMetadataView: MetadataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .pinterestRed
        let imageResource = ImageResource(downloadURL: URL(string: pin.image["original"]!.url)!, cacheKey: pin.image["original"]!.url)
        imageView.kf.setImage(with: imageResource)
        view.addSubview(imageView)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        commentMetadataView = MetadataView()
        commentMetadataView.imageView.image = UIImage(named: "comment-bubble")
        commentMetadataView.countLabel.text = String(pin.counts.comments)
        view.addSubview(commentMetadataView)
        
        savesMetadataView = MetadataView()
        savesMetadataView.imageView.image = UIImage(named: "save-icon")
        savesMetadataView.countLabel.text = String(pin.counts.saves)
        view.addSubview(savesMetadataView)
        
        noteLabel = UILabel()
        noteLabel.text = pin.note
        noteLabel.numberOfLines = 2
        noteLabel.textColor = .darkGray
        noteLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(noteLabel)
        
//        authorLabel = UILabel()
//        authorLabel.text = "From Diply" // CHANGE ME!!!!!!!!!
//        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        authorLabel.textColor = .darkGray
//        view.addSubview(authorLabel)
        
        openLinkButton = UIButton()
        openLinkButton.layer.cornerRadius = 10
        openLinkButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        openLinkButton.setTitle("Visit Site", for: .normal)
        openLinkButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        openLinkButton.setTitleColor(.gray, for: .normal)
        openLinkButton.addTarget(self, action: #selector(openPinLink), for: .touchUpInside)
        view.addSubview(openLinkButton)
        
        openPinterestUrlButton = UIButton()
        openPinterestUrlButton.layer.cornerRadius = 10
        openPinterestUrlButton.backgroundColor = .pinterestRed
        openPinterestUrlButton.setTitle("Open on Pinterest", for: .normal)
        openPinterestUrlButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        openPinterestUrlButton.setTitleColor(.white, for: .normal)
        openPinterestUrlButton.addTarget(self, action: #selector(openPinterestUrl), for: .touchUpInside)
        view.addSubview(openPinterestUrlButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(40)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(72)
        }
        
        savesMetadataView.snp.makeConstraints { make in
            make.leading.equalTo(noteLabel)
            make.top.equalTo(noteLabel.snp.bottom)
            make.height.equalTo(19)
        }
        
        commentMetadataView.snp.makeConstraints { make in
            make.top.height.equalTo(savesMetadataView)
            make.leading.equalTo(savesMetadataView.snp.trailing).offset(4)
        }
        
        openLinkButton.snp.makeConstraints { make in
            make.leading.equalTo(noteLabel)
            make.trailing.equalTo(noteLabel.snp.centerX).offset(-8)
            make.top.equalTo(savesMetadataView.snp.bottom).offset(16)
            make.height.equalTo(70)
        }
        
        openPinterestUrlButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(openLinkButton)
            make.leading.equalTo(noteLabel.snp.centerX).offset(8)
            make.trailing.equalTo(noteLabel)
        }
    }
    
    @objc func openPinLink() {
        guard let url = URL(string: pin.link) else {
            print("Couldn't open pin url")
            return
        }
        
        let browserVC = SFSafariViewController(url: url)
        browserVC.preferredBarTintColor = .pinterestRed
        present(browserVC, animated: true, completion: nil)
    }
    
    @objc func openPinterestUrl() {
        guard let url = URL(string: pin.url) else {
            print("Couldn't open pin url")
            return
        }
        
        let browserVC = SFSafariViewController(url: url)
        browserVC.preferredBarTintColor = .pinterestRed
        present(browserVC, animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

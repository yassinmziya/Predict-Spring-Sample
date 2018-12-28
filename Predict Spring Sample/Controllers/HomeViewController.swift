//
//  HomeViewController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/19/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HomeViewController: UIViewController {
    
    // data and data handling vars
    var pins: [Pin] = [] {
        didSet {
            collectionView.reloadData()
            reloadingOnScrollBottom = false
        }
    }
    var pinsPagingData: PagingData? = nil
    
    var isFilteringPins = false {
        didSet {
            if isFilteringPins {
                noPinsView.isHidden = true
                if filteredPins.count == 0 {
                    noSearchResultsView.isHidden = false
                    collectionView.isHidden = true
                } else {
                    noSearchResultsView.isHidden = true
                    collectionView.isHidden = false
                }
            } else {
                noSearchResultsView.isHidden = true
                filteredPinsPagingData = nil
                filteredPins = []
                if pins.count == 0 {
                    noPinsView.isHidden = false
                    collectionView.isHidden = true
                } else {
                    noPinsView.isHidden = true
                    collectionView.isHidden = false
                }
            }
        }
    }
    var filteredPins: [Pin] = [] {
        didSet {
            collectionView.reloadData()
            reloadingOnScrollBottom = false
        }
    }
    var filteredPinsPagingData: PagingData? = nil
    
    var reloadingOnScrollBottom = false

    // views
    var searchFieldContainer: UIView!
    var searchField: UITextField!
    var cancelSearchButton: UIButton!
    var searchViewControllerContainer = UIView()
    var searchViewController: SearchViewController!
    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var noPinsView: NoPinsEmptyStateView!
    var noSearchResultsView: NoSearchResultsEmptyStateView!
    var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // search bar setup
        searchField = UITextField()
        searchField.placeholder = "Search"
        searchField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        searchField.textColor = .darkGray
        searchField.backgroundColor = .searchBarGray
        searchField.clearButtonMode = .always
        searchField.delegate = self
        
        searchFieldContainer = UIView()
        searchFieldContainer.backgroundColor = .searchBarGray
        searchFieldContainer.layer.cornerRadius = 8
        searchFieldContainer.clipsToBounds = true
        searchFieldContainer.addSubview(searchField)
        view.addSubview(searchFieldContainer)
        
        cancelSearchButton = UIButton()
        cancelSearchButton.setTitle("Cancel", for: .normal)
        cancelSearchButton.setTitleColor(.darkGray, for: .normal)
        cancelSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        cancelSearchButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        view.addSubview(cancelSearchButton)
        
        // search window setup
        searchViewController = SearchViewController()
        searchViewController.delegate = self
        add(searchViewController, to: searchViewControllerContainer)
        view.addSubview(searchViewControllerContainer)
        
        // empty state views setup
        noPinsView = NoPinsEmptyStateView()
        noPinsView.refreshButton.addTarget(self, action: #selector(getInitData), for: .touchUpInside)
        view.addSubview(noPinsView)
        
        noSearchResultsView = NoSearchResultsEmptyStateView()
        noSearchResultsView.retryButton.addTarget(self, action: #selector(openSearchWindow), for: .touchUpInside)
        view.addSubview(noSearchResultsView)
        
        // collection view setup
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 30, right: 15)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PinPreviewCell.self, forCellWithReuseIdentifier: PinPreviewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getInitData), for: .valueChanged)
        view.addSubview(collectionView)
        
        // loading view
        loadingView = LoadingView()
        view.addSubview(loadingView)
        
        // run utils
        getInitData()
        isFilteringPins = false
        setupConstraints()
    }

    // MARK:- HELPERS
    func setupConstraints() {
        searchFieldContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        cancelSearchButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchFieldContainer)
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(searchFieldContainer.snp.trailing).offset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom).offset(16)
        }
        
        searchViewControllerContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(searchFieldContainer.snp.bottom)
        }
        
        noPinsView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom).offset(16)
        }
        
        noSearchResultsView.snp.makeConstraints { make in
            make.edges.equalTo(noPinsView)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(noSearchResultsView)
        }
    }
    
    @objc func getInitData() {
        NetworkManager.sharedInstantce.getLoggedInUserPins(pagingData: nil) { (pins, pagingData) in
            DispatchQueue.main.async {
                self.pins = pins
                self.pinsPagingData = pagingData
                self.isFilteringPins = false
                self.loadingView.removeFromSuperview()
            }
        }
        
        if searchViewController.interests.isEmpty {
            // only call if not already retrieved to save api calls
            NetworkManager.sharedInstantce.getLoggedInUserInterests { interests in
                DispatchQueue.main.async {
                    self.searchViewController.interests = interests
                }
            }
        }
        
        self.refreshControl.endRefreshing()
    }
    
    func getMorePins() {
        // use filterPinsPage data if available else use pinsPagingData
        guard let pagingData = self.filteredPinsPagingData ?? self.pinsPagingData else {
            print("no more pages")
            return
        }
        
        NetworkManager.sharedInstantce.getLoggedInUserPins(pagingData: pagingData) { (pins, pagingData) in
            DispatchQueue.main.async {
                self.pins.append(contentsOf: pins)
                self.pinsPagingData = pagingData ?? nil
            }
        }
    }
    
    @objc func openSearchWindow() {
        searchField.becomeFirstResponder()
    }
    
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pinVC = PinViewController()
        pinVC.pin = filteredPins.isEmpty ? pins[indexPath.row] : filteredPins[indexPath.row]
        navigationController?.pushViewController(pinVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPins.isEmpty ? pins.count : filteredPins.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinPreviewCell.identifier, for: indexPath) as! PinPreviewCell
        let pin = filteredPins.isEmpty ? pins[indexPath.row] :  filteredPins[indexPath.row]
        cell.noteLabel.text = pin.note
        let imageResource = ImageResource(downloadURL: URL(string: pin.image["original"]!.url)!, cacheKey: pin.image["original"]!.url)
        cell.imageView.kf.setImage(with: imageResource)
        
        return cell
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
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

// MARK:- UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        collectionView.isHidden = true
        noPinsView.isHidden = true
        noSearchResultsView.isHidden = true
        searchViewControllerContainer.isHidden = false
        
        // reveal cancel button
        searchFieldContainer.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-96)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text?.replacingOccurrences(of: " ", with: "%20"), query.count != 0 else {
            cancelSearch()
            return true
        }
        
        NetworkManager.sharedInstantce.searchLoggedInUserPins(query: query) { (pins, pagingData) in
            DispatchQueue.main.async {
                self.filteredPins = pins
                self.isFilteringPins = true
            }
        }
            
        searchField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        searchViewControllerContainer.isHidden = true
        
        // hide cancel button
        searchFieldContainer.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
        }
        return true
    }
    
    @objc func cancelSearch() {
        isFilteringPins = false
        searchField.resignFirstResponder()
    }
    
}

// MARK:- UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("did scroll")
        let bottomEdge: CGFloat = collectionView.contentOffset.y + collectionView.frame.height
        if(bottomEdge >= collectionView.contentSize.height) {
            if !reloadingOnScrollBottom {
                print("getting more pins")
                reloadingOnScrollBottom = true
                getMorePins()
            }
            print("bottom reached")
        }
    }
    
}

// MARK:- SearchViewControllerDelegate
extension HomeViewController: SearchViewControllerDelegate {
    
    func interestCellSelected(query: String) {
        let query = query.replacingOccurrences(of: " ", with: "%20")
        searchField.text = query
        NetworkManager.sharedInstantce.searchLoggedInUserPins(query: query) { (pins, pagingData) in
            DispatchQueue.main.async {
                self.filteredPins = pins
                self.isFilteringPins = true
            }
        }
        searchField.resignFirstResponder()
    }
    
}

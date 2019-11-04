//
//  DiscoverViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Variables
    let cellId = "CellId"; //Unique cell id
    var offset = UIOffset() //Offset for search bar text and icon
    
    //View Did load /////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white; //just to test
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId) //register collection view cell class
        setupViews(); //setup all views
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
    }
    
    //////////////////End View Did load
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    //Set Up Views /////////
    func setupViews() {
        
        view.addSubview(collectionView); // add collection view to view controller
        collectionView.delegate = self; // set delegate
        collectionView.dataSource = self; //set data source
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        
    }
    // Set Up Views End ///////////
    
    //Search Bar ///////////////
    func makeSearchBar() {
        let placeholderWidth: CGFloat = 250.0 // Replace with whatever value works for your placeholder text
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        offset = UIOffset(horizontal: searchBar.frame.width - placeholderWidth, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        navigationItem.titleView = searchBar
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 0, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setPositionAdjustment(offset, for: .search)
        
        return true
    }
    
    ///////////////////End Search Bar
    
    
    
    
    
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
        
        setTitleForIndex(menuIndex)
    }
    
    fileprivate func setTitleForIndex(_ index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
        
    }
    ///////////////////End Menu Bar
    
    //Collection View Set Up ////////////
    let collectionView: UICollectionView = { // collection view to be added to view controller
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout); //zero size with flow layout
        cv.translatesAutoresizingMaskIntoConstraints = false; //set it to false so that we can suppy constraints
        cv.backgroundColor = .white; // test
        cv.isPagingEnabled = true
        
        return cv;
    }();
    
    //deque cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! FeedCell
        cell.delegate = self
        
        return cell
    }
    
    
    // number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //size of each CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 10);
    }
    
    //Push to detail view if image in discover view is selected
    //Send image selected id to detail view 
    func colCategorySelected(postId: String) {
        let detailVC = DiscoverDetailViewController()
        detailVC.postId = postId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //Collection View end ////////////
    
    //Feed cell Delegate functions/////
    
    
    var lastVelocityYSign = 0
    func contentOffset(scrollView: UIScrollView) {
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        if lastVelocityYSign < 0 {
            //print("SCROLLING DOWN")
            if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -75.0) {
            }
        } else if lastVelocityYSign > 0 {
            //print("SCOLLING UP")
            if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -75.0) {
            }
        }
    }
   
    
} // End Class //////



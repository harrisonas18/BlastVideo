//
//  DiscoverDetailViewController.swift
//  VideoAppLatestUpdate
//
//  Created by Harrison Senesac on 8/2/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class DiscoverDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
        let cellId = "CellID"
        var postId = ""
        var post = Post()
        var user = UserObject()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpViews()
            UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    //Hides status bar before the view appears
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    //Loads the post that was selected based on the id of the post
    func loadPost() {
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.collectionView.reloadData()
            })
        }
    }
    //Loads user information for the post that was selected based on the user id
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
        
    }
    
    //Gets the index of the post that was selected based on the id of the post in the posts array
    //Uses the index of the id to pre scroll to the matching detail view post
    func getIndexPath(postId: String) -> Int {
        let index = posts.index(where: {$0.id == postId})
        return index!
    }
    
    
    //Scrolls to image that was selected in discover view
    var onceOnly = false
    var row = 0
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            row = getIndexPath(postId: postId)
            print("will display called")
            let indexToScrollTo = IndexPath(item: row, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
    
    //Collection View Set up ///////////////
    func setUpViews() {
        view.addSubview(collectionView); // add collection view to view controller
        collectionView.delegate = self; // set delegate
        collectionView.dataSource = self; //set data source
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let collectionView: UICollectionView = { // collection view to be added to view controller
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout); //zero size with flow layout
        cv.translatesAutoresizingMaskIntoConstraints = false; //set it to false so that we can supply constraints
        cv.backgroundColor = .white; // test
        cv.isPagingEnabled = true
        
        return cv;
    }();
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //size of each CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height);
    }
    //End Collection View Set Up ////////////
    

}



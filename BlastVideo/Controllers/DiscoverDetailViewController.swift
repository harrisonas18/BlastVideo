//
//  DiscoverDetailViewController.swift
//  VideoAppLatestUpdate
//
//  Created by Harrison Senesac on 8/2/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class DiscoverDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
        var postId = ""
        var post = Post()
        var user = UserModel()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            //loadPost()
            setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
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
    
    func getIndexPath(postId: String) -> Int {
        let index = posts.index(where: {$0.id == postId})
        return index!
    }
    
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
    
        
        func fetchUser(uid: String, completed:  @escaping () -> Void ) {
            Api.User.observeUser(withId: uid, completion: {
                user in
                self.user = user
                completed()
            })
            
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverDetailCell", for: indexPath) as! DiscoverDetailCollectionViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    
        
    

}



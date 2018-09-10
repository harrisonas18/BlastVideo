//
//  FeedCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import SDWebImage

// first UICollectionViewCell
class FeedCell: PostCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    let collectionView: UICollectionView = {
        let layout = PinterestLayout();
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout);
        cv.backgroundColor = .white; //testing
        cv.translatesAutoresizingMaskIntoConstraints = false;
        return cv;
    }();
    
    let cellId = "CellId"; // same as above unique id
    var posts = [Post]()
    
    override func setupViews(){
        super.setupViews()
        
        addSubview(collectionView);
        loadTopPosts()
        
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId);
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        //Collection View Constraints
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true;
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true;
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true;
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
        
        
    }
    
    func loadTopPosts() {
        posts.removeAll()
        self.collectionView.reloadData()
        Api.Post.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
        }
    }
    
    
    
    // Collection View methods /////////////////////////////////////////////////////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell;
    
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8.0
        cell.post = posts[indexPath.item]
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count;
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    // Collection View methods /////////////////////////////////////////////////////////////////////////
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension FeedCell: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return (375 / posts[indexPath.item].ratio!) / 2
    }
    
    
}

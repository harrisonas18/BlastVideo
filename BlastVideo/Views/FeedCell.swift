//
//  FeedCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import SDWebImage

protocol CellDelegate: class {
    func colCategorySelected(postId: String)
    
    func hideNavigationBar()
    func showNavigationBar()
    func contentOffset(scrollView: UIScrollView)
}

class FeedCell: PostCell, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {
    
    weak var delegate: CellDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    let cellId = "cellId"
    var numberOfItemsInSection = 0
    let myGroup = DispatchGroup()
    
    override func setupViews() {
        super.setupViews()
        
        loadLatestPosts()
        
        print("Posts count UIKit: ", posts.count)
        // Set the PinterestLayout delegate
        backgroundColor = .brown
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 65, left: 2, bottom: 50, right: 2);
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    var donePaginating = false
    
    
    func loadLatestPosts (){
        
        isLoadingPost = true
        Api.Post.getRecentPost(start: posts.first?.timestamp, limit: 9  ) { (results) in
            if results.count > 0 {
                results.forEach({ (result) in
                    posts.append(result.0)
                    users.append(result.1)
                })
            }
            isLoadingPost = false
            self.collectionView.reloadData()
        }
    }
    
    
    func loadOlderPosts () {
        guard !isLoadingPost else {
            return
        }
        isLoadingPost = true
        
        guard let lastPostTimestamp = posts.last?.timestamp else {
            isLoadingPost = false
            return
        }
        Api.Post.getOldPost(start: lastPostTimestamp, limit: 6) { (results) in
            if results.count == 0 {
                return
            }
            for result in results {
                posts.append(result.0)
                users.append(result.1)
            }
            self.collectionView.reloadData()
            isLoadingPost = false
        }
    }
    
    func loadTopPosts() {
        posts.removeAll()
        self.collectionView.reloadData()
        Api.Post.observeTopPosts { (post) in
            posts.append(post)
            self.collectionView.reloadData()
        }
    }
    // Collection View methods /////////////////////////////////////////////////////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostCell
        
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        
        cell.post = posts[indexPath.item]
        cell.user = users[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.colCategorySelected(postId: posts[indexPath.item].id!)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - super.frame.height {
            loadOlderPosts()
        }
        
        delegate?.contentOffset(scrollView: scrollView)
        
    }
  
}
//MARK: - PINTEREST LAYOUT DELEGATE
extension FeedCell: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return (375 / posts[indexPath.item].ratio!) / 2
        //return 200
    }
}


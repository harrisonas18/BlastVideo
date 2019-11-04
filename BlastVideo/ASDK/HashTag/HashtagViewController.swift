//
//  HashtagViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/26/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import GradientLoadingBar

class HashtagViewController: ASViewController<ASCollectionNode> {
    
    let layout = ProfilePostsLayout()
    var gradientBar : GradientLoadingBar?
    var refreshControl : UIRefreshControl?
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    var hashtag: String?
    
    private var collectionNode: ASCollectionNode {
        return node
    }
    
    init(hashtag: String) {
        self.hashtag = hashtag
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        collectionNode.delegate = self
        collectionNode.dataSource = self
        gradientBar = GradientLoadingBar(height: 5.0, isRelativeToSafeArea: true)
        gradientBar?.fadeIn()
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)
        
    }
    
    @objc func refreshContent(){
        refreshControl?.endRefreshing()
        clearPostData()
        self.isLoadingPost = false
        self.firstFetch = true

    }
    
    func clearPostData(){
    }
    
    func fetchNewBatchWithContext(_ context: ASBatchContext?) {
        if firstFetch {
            DispatchQueue.main.async {
                self.gradientBar?.fadeIn()
            }
            firstFetch = false
            self.isLoadingPost = true
            Api.HashTag.getHashtagPosts(hashtag: hashtag!, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.posts.append(result.0)
                        self.users.append(result.1)
                    })
                }
                self.newItems = results.count
                self.gradientBar?.fadeOut()
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
            }
            
        } else {
            guard !isLoadingPost else {
                context?.completeBatchFetching(true)
                return
            }
            isLoadingPost = true
            
            guard let lastPostTimestamp = posts.last?.timestamp else {
                isLoadingPost = false
                return
            }
            Api.HashTag.getMoreHashtagPosts(hashtag: hashtag!, start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    return
                }
                for result in results {
                    self.posts.append(result.0)
                    self.users.append(result.1)
                }
                self.newItems = results.count
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
                
            }
        }
    }
    
    func addRowsIntoTableNode(newPhotoCount newPhotos: Int) {
        let indexRange = (posts.count - newPhotos..<posts.count)
        let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
            self.collectionNode.insertItems(at: indexPaths)
        }
    }
    
}

extension HashtagViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
}

extension HashtagViewController: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
        
    }
    
}

extension HashtagViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let post = self.posts[indexPath.row]
        let user = self.users[indexPath.row]
        return CollectionPostCellNode(post: post, user: user)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        fetchNewBatchWithContext(context)
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let user = users[indexPath.item]
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HashtagViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let boldFont = UIFont.init(name: "Modulus-Bold", size: 24.0)
        let navTitle = NSMutableAttributedString(string: "#\(hashtag!)", attributes:[
            NSAttributedString.Key.font: boldFont!,
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
}

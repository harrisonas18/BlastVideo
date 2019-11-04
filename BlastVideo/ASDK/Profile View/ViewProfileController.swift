//
//  ViewProfileController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 4/23/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import GradientLoadingBar

class ViewProfileController: ASViewController<ASCollectionNode> {
    
    var userPosts: [Post] = []
    var userFavorites: [Post] = []
    var userFavoriteUsers: [UserObject] = []
    var user = UserObject()
    var newPhotos = 0
    var isLoadingPost = false
    var firstFetchPosts = true
    var firstFetchFavs = true
    var isPostView = true
    var headerNode: ProfileHeaderNode?
    let layout = ProfilePostsLayout()
    var collectionNode: ASCollectionNode
    var refreshControl : UIRefreshControl?
    var gradientBar : GradientLoadingBar?
    
    init(user: UserObject) {
        
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
        self.user = user
        super.init(node: collectionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBar = BottomGradientLoadingBar(height: 2.5, durations: Durations(fadeIn: 1.0, fadeOut: 1.0, progress: 1.5), gradientColorList: [.red, .blue, .green], isRelativeToSafeArea: true, onView: navigationController?.navigationBar)
        gradientBar?.show()
        self.setupNavBar()
        headerNode = ProfileHeaderNode(user: user)
        headerNode?.contentNode.delegate = self
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)
    }
    
    @objc func refreshContent(){
        gradientBar?.show()
        refreshControl?.endRefreshing()
        clearPostData()
        firstFetchPosts = true
        firstFetchFavs = true
        self.isLoadingPost = false
        collectionNode.reloadData()
    }
    
    func clearPostData(){
        userPosts.removeAll()
        userFavorites.removeAll()
        userFavoriteUsers.removeAll()
    }
    
    
    func addRowsIntoTableNode(newPhotoCount newPhotos: Int) {
        if isPostView {
            let indexRange = (userPosts.count - newPhotos..<userPosts.count)
            let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: indexPaths)
            }
        } else {
            let indexRange = (userFavorites.count - newPhotos..<userFavorites.count)
            let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: indexPaths)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// MARK: ASTableDataSource / ASTableDelegate

extension ViewProfileController: ASCollectionDataSource, ASCollectionDelegate, UserProfileHeaderDelegate {
    
    func trackSelectedIndex(_ theSelectedIndex: Int) {
        
        switch theSelectedIndex {
            
        case 0: // this means the first segment was chosen
            isPostView = true
            self.isLoadingPost = false
            collectionNode.reloadData()
            break
            
        case 1: // this means the middle segment was chosen
            isPostView = false
            self.isLoadingPost = false
            collectionNode.reloadData()
            break
            
        default:
            break
        }
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        
        if kind == UICollectionView.elementKindSectionHeader {
            return headerNode!
        } else {
            assert(false, "Invalid Header Type")
        }
    }
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isPostView {
            return self.userPosts.count
        } else {
            return self.userFavorites.count
        }
        
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        if isPostView {
            let post = self.userPosts[indexPath.row]
            return CollectionPostCellNode(post: post, user: nil)
        } else {
            let post = self.userFavorites[indexPath.row]
            return CollectionPostCellNode(post: post, user: user)
        }
    }
    
    func shouldBatchFetchForCollectionNode(collectionNode: ASCollectionNode) -> Bool {
        if self.isLoadingPost {
            return false
        } else {
            return true
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        if isPostView {
            fetchPostBatchWithContext(context)
        } else {
            fetchFavBatchWithContext(context)
        }
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isPostView {
            let post = self.userPosts[indexPath.item]
            let detailViewController = ASDetailViewController(post: post, user: user)
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            let post = self.userFavorites[indexPath.item]
            let user = self.userFavoriteUsers[indexPath.item]
            let detailViewController = ASDetailViewController(post: post, user: user)
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension ViewProfileController: ASCollectionDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: 10, height: 50), CGSize(width: 10, height: 225))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 50), CGSize(width: itemWidth, height: 300))
    }
    
}

extension ViewProfileController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: user.username?.lowercased() ?? "Profile", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

extension ViewProfileController {
    
    func fetchPostBatchWithContext(_ context: ASBatchContext?) {
        if firstFetchPosts {
            gradientBar?.show()
            firstFetchPosts = false
            self.isLoadingPost = true
            Api.MyPosts.getProfilePosts(userId: user.id!, start: userPosts.first?.timestamp, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.userPosts.append(result)
                    })
                }
                self.gradientBar?.hide()
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
            }
            
        } else {
            guard !self.isLoadingPost else {
                context?.completeBatchFetching(true)
                return
            }
            self.isLoadingPost = true
            
            guard let lastPostTimestamp = userPosts.last?.timestamp else {
                self.isLoadingPost = false
                return
            }
            Api.MyPosts.getOlderProfilePosts(userId: user.id!, start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    return
                }
                for result in results {
                    self.userPosts.append(result)
                }
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
                
            }
        }
    }
    
    func fetchFavBatchWithContext(_ context: ASBatchContext?) {
        if firstFetchFavs {
            DispatchQueue.main.async {
                self.gradientBar?.show()
            }
            firstFetchFavs = false
            self.isLoadingPost = true
            
            Api.Favorites.getFavorites(userId: user.id!, start: userFavorites.first?.timestamp, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.userFavorites.append(result.0)
                        self.userFavoriteUsers.append(result.1)
                    })
                }
                self.gradientBar?.hide()
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
            }
            
        } else {
            guard !self.isLoadingPost else {
                context?.completeBatchFetching(true)
                return
            }
            self.isLoadingPost = true
            
            guard let lastPostTimestamp = userFavorites.last?.timestamp else {
                self.isLoadingPost = false
                return
            }
            Api.Favorites.getOlderFavorites(userId: user.id!, start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    self.isLoadingPost = false
                    context?.completeBatchFetching(true)
                    return
                }
                for result in results {
                    self.userFavorites.append(result.0)
                    self.userFavoriteUsers.append(result.1)
                }
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
            }
        }
    }
    
    
    
}

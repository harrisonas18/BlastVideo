//
//  NewProfileController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import IGListKit

class NewProfileViewController: ASViewController<ASCollectionNode> {
    
    var isPostView = true
    var headerNode: ProfileHeaderNode?
    static let shared = NewProfileViewController()
    let collectionNode: ASCollectionNode!
    var refreshControl : UIRefreshControl?
    let layout = UICollectionViewFlowLayout()
    
    var feedItems: [FeedItem] = [FeedItem]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()
    
    init() {
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 5.0
        layout.itemSize = CGSize(width: (UIScreen.screenWidth()/2) , height: 220)
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: self.collectionNode)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        self.adapter.dataSource = self
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get movie detail
        Api.User.observeCurrentUser { (currentUser) in
            currentUserGlobal = currentUser
            self.fetchDetailInfo()
        }
    }
    
    @objc func refreshContent(){
        NewProfileData.shared.feedItems.removeAll()
        fetchDetailInfo()
    }
    
    private func fetchDetailInfo() {
        NewProfileData.shared.fetchUserPosts { (feedItems) in
            self.feedItems = feedItems
            self.updateUI()
        }
    }
    
    private func updateUI() {
        adapter.performUpdates(animated: true, completion: nil)
        refreshControl?.endRefreshing()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

extension NewProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.screenWidth()/3) - 30
        return CGSize(width: width , height: 220)
    }
    
}

extension NewProfileViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is FeedItem:
            let feedController = NewProfileSectionController()
            feedController.delegate = self
            feedController.pushViewDelegate = self
            feedController.pushUserDelegate = self
            return feedController
        default:
            return ListSectionController()
        }
        
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        //return posts as [ListDiffable]
        let items: [ListDiffable] = feedItems
        return items
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

extension NewProfileViewController: PushDataDelegate {
    func pushData(feedItems: [FeedItem]) {
        self.feedItems = feedItems
        adapter.performUpdates(animated: false, completion: nil)
    }
}
extension NewProfileViewController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
extension NewProfileViewController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        let detailViewController = ViewProfileController(user: user)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}



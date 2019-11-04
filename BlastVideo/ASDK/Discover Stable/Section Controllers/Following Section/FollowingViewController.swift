//
//  FollowingViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/29/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import AsyncDisplayKit
import IGListKit
import XLPagerTabStrip

class FollowingController: ASViewController<ASCollectionNode> {
    
    static let shared = FollowingController()
    let navigation = NavigationBarNode()
    let collectionNode: ASCollectionNode!
    var refreshControl : UIRefreshControl?
    var layout: UICollectionViewFlowLayout
    
    var pageTitle: String?
    
    var feedItems: [FeedItem] = [FeedItem]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()
    
    init() {
        layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: self.collectionNode)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        self.adapter.dataSource = self
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)
        
    }
    
    @objc func refreshContent(){
        FollowingData.shared.feedItems.removeAll()
        fetchDetailInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        fetchDetailInfo()
        print("View loaded")
    }
    
    private func fetchDetailInfo() {
        FollowingData.shared.fetchPosts { (feedItems) in
            //print("Following Fetch posts called - UI")
            self.feedItems = feedItems
            self.updateUI()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true, completion: nil)
        }
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
    }

    
    
}

extension FollowingController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is FeedItem:
            let feedController = FollowingSectionController()
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

extension FollowingController: FollowingDataDelegate {
    func pushData(feedItems: [FeedItem]) {
        self.feedItems = feedItems
        adapter.performUpdates(animated: false, completion: nil)
    }
}
extension FollowingController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
//TODO: Add code to set up header and two view controllers which contains users posts and favorites
//Set up layout based on if the user has posts, favorites
//Update model to reflect if user has posts/favorites - check this then make network call
extension FollowingController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        let vc = PushProfileViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowingController {
    
    func setupNavBar() {
        let backBarButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func pushSearch(){

    }
    
}

extension FollowingController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Following")
    }
}

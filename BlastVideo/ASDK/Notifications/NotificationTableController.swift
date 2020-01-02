//
//  NotificationTableController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/28/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import SJSegmentedScrollView
import XLPagerTabStrip
import IGListKit
import DeepDiff

class NotificationTableController: ASViewController<ASTableNode> {
    
    var feedItems: [FeedItem] = [FeedItem]()
    var newPosts = 0
    var isLoading = false
    var count = 0
    var dataDelegate: PushDiscoverDataDelegate?
    var notifications = [PushNotification]()
    var groupNotif = [[PushNotification]]()
    var users = [UserObject]()
    let refresh = UIRefreshControl()
    
    var pageTitle: String?
    
    private var tableNode: ASTableNode {
        return node
    }
    
    init() {
        super.init(node: ASTableNode())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Remove badge here after a 3 second delay
        //Post notification to tab bar view controller
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveNotificationBadgeOnTabBarIcon"), object: nil)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        loadNotifications()
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .none
        tableNode.view.addSubview(refresh)
        tableNode.view.alwaysBounceVertical = true
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        NSLayoutConstraint.activate([
            refresh.widthAnchor.constraint(equalToConstant: 25),
            refresh.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    @objc func refreshData(){
        notifications.removeAll()
        loadNotifications()
        refresh.endRefreshing()
    }
    
    func sortByTime(notifications: [PushNotification]){
        //Group notifications by timestamp
        
//        let cal = Calendar.current
//        let grouped = Dictionary(grouping: notifications, by: {$0.timestamp})
//        
        
        
    }
    
    func loadNotifications() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        Api.Notification.observeNotification(withId: currentUser.uid , completion: {
            notification in
            guard let uid = notification.from else {
                return
            }
            self.fetchUser(uid: uid, completed: {
                //Show badge on notifications icon on tab bar
                //Send notification to TabBarViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNotificationBadgeOnTabBarIcon"), object: nil)
                self.notifications.insert(notification, at: 0)
                self.tableNode.reloadData()
            })
        })
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    
    func fetchPosts(){
        
        let label = ASTextNode()
        label.view.translatesAutoresizingMaskIntoConstraints = false
        //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
        label.frame = .zero
        label.attributedText = NSAttributedString(string: "No Notifications", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        self.node.addSubnode(label)
        NSLayoutConstraint.activate([
            label.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.view.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
            label.view.heightAnchor.constraint(equalToConstant: 45),
            label.view.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        DispatchQueue.main.async {
            let results = diff(old: self.feedItems, new: self.feedItems)
            self.tableNode.view.reload(changes: results, updateData: ({
                
            }))
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension NotificationTableController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        
    }
}

// MARK: ASTableDataSource / ASTableDelegate

extension NotificationTableController: ASTableDataSource, ASTableDelegate {
    

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = NotificationTableNodeCell(notification: notifications[indexPath.row], user: users[indexPath.row])
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        if isLoading {
            return false
        }
        return false
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        if !DiscoverData.shared.isLoadingPost && !DiscoverData.shared.firstFetch && DiscoverData.shared.newItems > 7 {
            isLoading = true
            DiscoverData.shared.fetchMorePosts{ (feedItems) in
                DispatchQueue.main.async {
                    let results = diff(old: self.feedItems, new: feedItems)
                    self.tableNode.view.reload(changes: results, updateData: ({
                        self.feedItems = feedItems
                    }))
                    
                }
                self.isLoading = false
                context.completeBatchFetching(true)
            }
        } else {
            context.completeBatchFetching(true)
        }
    }
    
}

extension NotificationTableController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Notifications", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
//        navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
        
    }
}




//
//  File.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/21/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import FirebaseAuth
import AsyncDisplayKit
import NotificationBannerSwift
import PhotosUI

class ASDetailViewController: ASViewController<ASTableNode> {
    
    // MARK: - Variables
    let post: Post
    let user: UserObject
    var livePhoto: PHLivePhoto?
    var pushUserDelegate: PushUsernameDelegate?
    
    private var tableNode: ASTableNode {
        return node
    }
    
    // MARK: - Object life cycle
    init(post: Post, user: UserObject) {
        self.post = post
        self.user = user
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.backgroundColor = UIColor.primaryBackgroundColor()
        tableNode.view.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.view.backgroundColor = .white
        
    }
}

extension ASDetailViewController: ASTableDataSource, ASTableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: ASTableView, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let node = ProductCellNode(post: self.post, user: self.user)
        node.detailNode.delegate = self
        node.detailNode.hashtagDelegate = self
        return node
    }
    
}

extension ASDetailViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let font = UIFont.init(name: "Modulus-Bold", size: 24.0)
        let navTitle = NSMutableAttributedString(string: "PHOTO", attributes:[
            NSAttributedString.Key.font: font!,
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "menuButton"), style: .plain, target: self, action: #selector(menuButtonPressed))
        rightBarButtonItem.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let backBarButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
    }
    
    //TODO: -When post is deleted in action sheet, delete post in collection node and remove index
    //      -Delete from array of posts in discover controller
    //      -Delete from firebase myposts, posts, and feed - use firebase functions to do this
    @objc func menuButtonPressed() {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: nil))
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        if currentUser.uid == post.uid {
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                Api.MyPosts.deletePost(post: self.post)
                Api.Post.deletePost(post: self.post)
                let delete = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Post Deleted",                                                   attributes: [:]),
                                                          style: .danger,
                                                          colors: nil)
                delete.duration = 3.0
                delete.show()
                self.navigationController?.popViewController(animated: true)
            }))
        } 
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ASDetailViewController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        pushUserDelegate?.pushUser(user: user)
    }
}

extension ASDetailViewController: PushHashtagDelegate {
    func pushHashtag(hashtag: String) {
        let controller = NewHashtagViewController(hashtag: hashtag)
        //controller.hashtag = hashtag
        navigationController?.pushViewController(controller, animated: true)
    }
}

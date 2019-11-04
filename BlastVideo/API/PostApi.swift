//
//  PostApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import NotificationBannerSwift

class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeLikeCount(withPostId id: String, completion: @escaping (Int, UInt) -> Void) {
        var likeHandler: UInt!
        likeHandler = REF_POSTS.child(id).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
              //  Database.database().reference().removeObserver(withHandle: ref)
                completion(value, likeHandler)
            }
        })
        
    }
    
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                }
            })
        })
    }
    
    func getRecentPost(start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        var feedQuery = REF_POSTS.queryOrdered(byChild: "timestamp")
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            feedQuery = feedQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: "timestamp").queryLimited(toLast: limit)
        } else {
            feedQuery = feedQuery.queryLimited(toLast: limit)
        }
        // Call Firebase API to retrieve the latest records
        feedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            
            var results: [(post: Post, user: UserObject)] = []
            
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        results.append((post: post, user: user))
                        myGroup.leave()
                    })
                })
            }
            myGroup.notify(queue: .main) {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completionHandler(results)
            }
        })
        
    }
    
    func getOldPost(start timestamp: Int, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        
        let feedOrderQuery = REF_POSTS.queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedOrderQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            
            let myGroup = DispatchGroup()
            
            var results: [(post: Post, user: UserObject)] = []
            
            for (_, item) in items.enumerated() {
                
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        results.append((post: post, user: user))
                        myGroup.leave()
                    })
                })
            }
            myGroup.notify(queue: DispatchQueue.main, execute: {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completionHandler(results)
            })
        })
        
    }
    
    
    func deletePost(post: Post){
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        if currentUser.uid == post.uid {
            let ref = REF_POSTS.child(post.id!)
            
            ref.removeValue { (error, ref) in
                if error == nil {
//                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Post Removed", attributes: [:]), style: .success, colors: nil)
//                    success.duration = 3.0
//                    success.show()
                } else {
//                    let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
//                    error.duration = 3.0
//                    error.show()
                }
            }
        } else {
//            let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
//            error.duration = 3.0
//            error.show()
        }
        
        
    }
    
    
}

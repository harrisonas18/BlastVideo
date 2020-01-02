//
//  MyPostsApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase
import NotificationBannerSwift
import FirebaseAuth

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
    func observeMyPostsCount(id: String, completion: @escaping (Int) -> Void){
        print("Observe posts id: ",id)
        REF_MYPOSTS.child(id).child("myPostsCount").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Int {
                print("Value from api my posts count: ", value)
                completion(value)
            } else {
                print("Value from api my posts count: ", snapshot.value as? Int)
                completion(0)
            }
        }
    }
    
    func getProfilePosts(userId: String, start timestamp: Int? = nil, limit: UInt, completion: @escaping ([Post]) -> Void) {
        
        let feedQuery = REF_MYPOSTS.child(userId).child("posts").queryLimited(toLast: limit)
        //feedQuery = feedQuery.queryLimited(toLast: limit)
        
        feedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [Post] = []
            print(snapshot.key)
            print(snapshot.ref)
            print("Snapshot object count: ",snapshot.children.allObjects.count)
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    results.append(post)
                    myGroup.leave()
                })
            }
            myGroup.notify(queue: .main) {
                results.sort(by: {$0.timestamp! > $1.timestamp! })
                completion(results)
            }
        }
    }
    
    func getOlderProfilePosts(userId: String, start timestamp: Int, limit: UInt, completion: @escaping ([Post]) -> Void) {
        
        let feedQuery = REF_MYPOSTS.child(userId).child("posts").queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [Post] = []
            
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key , completion: { (post) in
                    results.append(post)
                    myGroup.leave()
                })
            }
            myGroup.notify(queue: .main) {
                results.sort(by: {$0.timestamp! > $1.timestamp! })
                completion(results)
            }
        }
    }
    
    func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYPOSTS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
    func deletePost(post: Post) {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        if currentUser.uid == post.uid {
            let ref = REF_MYPOSTS.child(currentUser.uid).child("posts").child(post.id!)
            
            ref.removeValue { (error, ref) in
                if error == nil {
                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Post Removed", attributes: [:]), style: .success, colors: nil)
                    success.duration = 3.0
                    success.show()
                } else {
                    let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
                    error.duration = 3.0
                    error.show()
                }
            }
        } else {
            let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
            error.duration = 3.0
            error.show()
        }
    }
    
}//end class

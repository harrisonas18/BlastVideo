//
//  FollowApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FeedApi {

//    init() {
//        REF_FEED.keepSynced(true)
//    }
    
    var REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    func observeFeedCount(completion: @escaping (Int) -> Void){
        Database.database().reference().child("feed").child(currentUserGlobal.id ?? "").child("myFeedCount").observeSingleEvent(of: .value) { (snapshot) in
            //print("Value: ", snapshot.value)
            if let value = snapshot.value as? Int {
                //print("Value: ", value)
                completion(value)
            } else {
                completion(0)
            }
        }
    }
    
    func getRecentFeed(withId id: String, start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedQuery = REF_FEED.child(id).child("posts").queryLimited(toLast: limit)
        //feedQuery = feedQuery.queryLimited(toLast: limit)
        
        
        // Call Firebase API to retrieve the latest records
        feedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            
            let value = snapshot.value as? NSDictionary
            //print(value)
            let username = value?["username"] as? String ?? ""
            
            let myGroup = DispatchGroup()
            //print("Items: ",items.count)
            
            var results: [(post: Post, user: UserObject)] = []

            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        results.append((post, user))
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
    
    
    func getOldFeed(withId id: String, start timestamp: Int, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedQuery = REF_FEED.child(id).child("posts").queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)

        feedLimitedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            let myGroup = DispatchGroup()
            var results: [(post: Post, user: UserObject)] = []

            for (_, item) in items.enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        results.append((post, user))
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

    
    func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).child("posts").observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
}

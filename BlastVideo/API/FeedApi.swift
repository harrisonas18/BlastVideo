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
    
    //MARK: Function: observeFeed
    func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                if let post = post {
                    completion(post)
                } else {
                    print("Error ID: Post ID Not Found\nLocation: FeedApi.swift\nFunction:observeFeed")
                }
            })
        })
    }
    //MARK: Function: observeFeedCount
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
    //MARK: Function: getRecentFeed
    func getRecentFeed(withId id: String, start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        var feedQuery = REF_FEED.child(id).child("posts").queryOrdered(byChild: "timestamp")
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            feedQuery = feedQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: "timestamp").queryLimited(toLast: limit)
        } else {
            feedQuery = feedQuery.queryLimited(toLast: limit)
        }
        // Call Firebase API to retrieve the latest records
        feedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            //print("in snapshot")
            //print(snapshot.childrenCount)
            var results: [(post: Post, user: UserObject)] = []
            
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                print("feed api item id: ", item.key)
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    if let post = post {
                        Api.User.observeUser(withId: post.uid!, completion: { (user) in
                            results.append((post: post, user: user))
                            //print("Results: ",results)
                            myGroup.leave()
                        })
                    } else {
                        print("Error ID: Post ID Not fount\nLocation: FeedApi.swift\nFunction: getRecentFeed")
                    }
                    
                })
            }
//            for item in results {
//                print("Feed API item id fetch posts list",item.post.id!)
//            }
            myGroup.notify(queue: .main) {
                //print("resullts")
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completionHandler(results)
            }
        })
        
    }
    
    //MARK: Function: getOldFeed
    func getOldFeed(withId id: String, start timestamp: Int, limit: UInt, completionHandler: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedOrderQuery = REF_FEED.child(id).child("posts").queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedOrderQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            
            let myGroup = DispatchGroup()
            
            var results: [(post: Post, user: UserObject)] = []
            
            for (_, item) in items.enumerated() {
                
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    if let post = post {
                        Api.User.observeUser(withId: post.uid!, completion: { (user) in
                            results.append((post: post, user: user))
                            myGroup.leave()
                        })
                    } else {
                        print("Error ID: Post ID Not fount\nLocation: FeedApi.swift\nFunction: getOldFeed")
                    }
                })
            }
            myGroup.notify(queue: DispatchQueue.main, execute: {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completionHandler(results)
            })
        })
        
    }

    //MARK: Function: observeFeedRemoved
    func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).child("posts").observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                if let post = post {
                    completion(post)
                } else {
                    print("Error ID: Post ID Not Found\nLocation: FeedApi.swift\nFunction:observeFeedRemoved")
                }
            })
        })
    }
}

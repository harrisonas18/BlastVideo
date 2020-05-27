//
//  HashTagApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase
class HashTagApi {
    var REF_HASHTAG = Database.database().reference().child("hashTag")
    
    
    func observePostCount(id: String, completion: @escaping (Int) -> Void){
        Database.database().reference().child("hashTag").child(id).child("hashtagPostsCount").observeSingleEvent(of: .value) { (snapshot) in
            print("Value: ", snapshot.value)
            if let value = snapshot.value as? Int {
                print("Value: ", value)
                completion(value)
            } else {
                completion(0)
            }
        }
    }
    
    func fetchHashTags(completion: @escaping ([String])->Void){
        REF_HASHTAG.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            var results: [String] = []
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                results.append(item.key)
            }
            completion(results)
        }
        
    }
    
    func fetchPosts(withTag tag: String, completion: @escaping (String) -> Void) {
        REF_HASHTAG.child(tag.lowercased()).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    func getHashtagPosts(hashtag: String, start timestamp: Int? = nil, limit: UInt, completion: @escaping ([(Post, UserObject)]) -> Void) {
        
        var feedQuery = REF_HASHTAG.child(hashtag.lowercased()).child("posts").queryOrdered(byChild: "timestamp")
        feedQuery = feedQuery.queryLimited(toLast: limit)
        
        feedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [(Post, UserObject)] = []
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
                completion(results)
            }
        }
    }
    
    func getMoreHashtagPosts(hashtag: String, start timestamp: Int, limit: UInt, completion: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedQuery = REF_HASHTAG.child(hashtag.lowercased()).queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [(Post, UserObject)] = []
            
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
                completion(results)
            }
        }
    }
    
    
    
}

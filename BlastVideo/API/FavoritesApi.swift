//
//  FavoritesApi.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/1/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import FirebaseDatabase
import NotificationBannerSwift

class FavoritesApi {
    var REF_MYPOSTS = Database.database().reference().child("favorites")
    
    
    func observeFavsCount(id: String, completion: @escaping (Int) -> Void){
        Database.database().reference().child("favorites").child(id).child("myFavoritesCount").observeSingleEvent(of: .value) { (snapshot) in
            //print("Value: ", snapshot.value)
            if let value = snapshot.value as? Int {
                //print("Value: ", value)
                completion(value)
            } else {
                completion(0)
            }
        }
    }
    
    func loadFavButton(post: Post, completion: @escaping (Bool) -> Void){
        if let id = currentUserGlobal.id {
            let query = REF_MYPOSTS.child(id).child(post.id!)
            var count: Bool = false
            query.observeSingleEvent(of: .value) { (snapshot) in
                count = snapshot.hasChildren()
                completion(count)
            }
        } else {
            completion(false)
        }
        
    }
    
    func addToFavorites(user: UserObject, post: Post){
        guard (user.id != nil) && (post.id != nil) else {
            return
        }
        let ref = REF_MYPOSTS.child(user.id!).child("posts").child(post.id!)
        ref.setValue(["timestamp": post.timestamp]) { (error, ref) in
            if error == nil {
                let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Added to Favorites", attributes: [:]), style: .success, colors: nil)
                success.duration = 3.0
                success.show()
            } else {
                let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error", attributes: [:]), style: .danger, colors: nil)
                error.duration = 3.0
                error.show()
            }
        }
    }
    
    func removeFromFavorites(user: UserObject, post: Post) {
        //Bug: App crashes when user not logged in and toggles favorite button
        let ref = REF_MYPOSTS.child(user.id!).child("posts").child(post.id!)
        
        ref.removeValue { (error, ref) in
            if error == nil {
                let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Removed from Favorites", attributes: [:]), style: .success, colors: nil)
                success.duration = 3.0
                success.show()
            } else {
                let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error", attributes: [:]), style: .danger, colors: nil)
                error.duration = 3.0
                error.show()
            }
        }
    }
    
    
    func getFavorites(userId: String, start timestamp: Int? = nil, limit: UInt, completion: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedQuery = REF_MYPOSTS.child(userId).child("posts").queryLimited(toLast: limit)
        //feedQuery = feedQuery.queryLimited(toLast: limit)
        
        feedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [(Post, UserObject)] = []
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    if let post = post {
                        Api.User.observeUser(withId: post.uid!, completion: { (user) in
                            results.append((post, user))
                            myGroup.leave()
                        })
                    } else {
                        print("Error ID: Post ID Not fount\nLocation: FavoritesApi.swift\nLine:97")
                    }
                    
                })
            }
            myGroup.notify(queue: .main) {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completion(results)
            }
        }
    }
    
    func getOlderFavorites(userId: String, start timestamp: Int, limit: UInt, completion: @escaping ([(Post, UserObject)]) -> Void) {
        
        let feedQuery = REF_MYPOSTS.child(userId).child("posts").queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects
            let myGroup = DispatchGroup()
            var results: [(Post, UserObject)] = []
            
            for (_, item) in (items as! [DataSnapshot]).enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    if let post = post {
                        Api.User.observeUser(withId: post.uid!, completion: { (user) in
                            results.append((post, user))
                            myGroup.leave()
                        })
                    } else {
                        print("Error ID: Post ID Not fount\nLocation: FavoritesApi.swift\nLine:129")
                    }
                })
            }
            myGroup.notify(queue: .main) {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp! })
                completion(results)
            }
        }
    }
}

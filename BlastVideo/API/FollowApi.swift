//
//  FollowApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2019 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String) {
        Api.MyPosts.REF_MYPOSTS.child(id).child("posts").observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    if let value = dict[key] as? [String: Any] {
                        let timestampPost = value["timestamp"] as! Int
                        Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child("posts").child(key).setValue(["timestamp": timestampPost])
                        print("Added post key: ", key)
                    }
                    
                }
            }
        })
        REF_FOLLOWERS.child(id).child("followers").child(Api.User.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child("following").child(id).setValue(true)
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        let newNotificationReference = (Api.Notification.REF_NOTIFICATION.child(id) as AnyObject).child("\(id)-\(Api.User.CURRENT_USER!.uid)")
        newNotificationReference.setValue(["from": Api.User.CURRENT_USER!.uid, "objectId": Api.User.CURRENT_USER!.uid, "type": "follow", "timestamp": timestamp])

    }
    
    //Removes user from Current users follow feed
    //Removes user from current user following list
    //Removes current user from user followers list
    func unFollowAction(withUser id: String) {
        
        Api.MyPosts.REF_MYPOSTS.child(id).child("posts").observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child("posts").child(key).removeValue()
                    print("removed post key: ", key)
                }
            }
        })
        
        REF_FOLLOWERS.child(id).child("followers").child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child("following").child(id).setValue(NSNull())
        
        let newNotificationReference = Api.Notification.REF_NOTIFICATION.child(id).child("\(id)-\(Api.User.CURRENT_USER!.uid)")
        newNotificationReference.setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child("followers").child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            //print("Snapshot value following: ", snapshot.value)
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })

    }
    
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
}

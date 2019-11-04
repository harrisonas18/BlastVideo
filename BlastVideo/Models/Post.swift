//
//  Post.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseAuth
import IGListKit

class Post {
    
    var caption: String? = nil
    var photoUrl: String? = nil
    var uid: String? = nil
    var id: String? = nil
    var likeCount: Int? = 0
    var likes: Dictionary<String, Any>? = ["User": 1]
    var isLiked: Bool? = false
    var ratio: CGFloat? = 0.66
    var videoUrl: String? = nil
    var timestamp: Int? = 0
    var user: UserObject?
    
}

extension Post {
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        post.timestamp = dict["timestamp"] as? Int
        if post.likeCount == nil {
            post.likeCount = 0
        }
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
      
        return post
    }
}

extension Post: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Post else { return false }
        return caption == object.caption
    }
}


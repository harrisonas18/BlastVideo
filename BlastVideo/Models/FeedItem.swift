//
//  Video.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import IGListKit
import DeepDiff

class FeedItem {
    
    let id: String
    let post: Post
    let user: UserObject
    
    
    init(id: String, post: Post, user: UserObject) {
        self.id = post.id!
        self.post = post
        self.user = user
    }

}

extension FeedItem: DiffAware {
    var diffId: String {
        return id
    }
    
    static func compareContent(_ a: FeedItem, _ b: FeedItem) -> Bool {
        return true
    }
    
    typealias DiffId = String
    
}

extension FeedItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    
}



//
//  Hashtag.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.

import Foundation
import IGListKit

class Hashtag: Codable {
    var hashtag: String? = nil
    var image1: String? = nil
    var image2: String? = nil
}

extension Hashtag {
    static func transformHashtag(dict: [String: Any], key: String) -> Hashtag {
        let tag = Hashtag()
        tag.hashtag = dict["hashtag"] as? String
        tag.image1 = dict["image1"] as? String
        tag.image2 = dict["image2"] as? String
        return tag
    }
}

//extension Hashtag: ListDiffable {
//    func diffIdentifier() -> NSObjectProtocol {
//        return id! as NSObjectProtocol
//    }
//
//    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
//        guard self !== object else { return true }
//        guard let object = object as? UserObject else { return false }
//        return profileImageUrl == object.profileImageUrl &&
//            isFollowing == object.isFollowing && realName == object.realName && bio == object.bio
//    }
//}

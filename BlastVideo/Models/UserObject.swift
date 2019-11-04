//
//  User.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import IGListKit

class UserObject: Codable {
    var email: String? = nil
    var profileImageUrl: String? = nil
    var username: String? = nil
    var id: String? = nil
    var isFollowing: Bool? = false
    // var has favorites bool
    // profile name string
}

extension UserObject {
    static func transformUser(dict: [String: Any], key: String) -> UserObject {
        let user = UserObject()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        return user
    }
}

extension UserObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? UserObject else { return false }
        return profileImageUrl == object.profileImageUrl &&
            isFollowing == object.isFollowing 
    }
}

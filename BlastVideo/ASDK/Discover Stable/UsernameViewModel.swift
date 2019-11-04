//
//  UsernameViewModel.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import IGListKit

final class UsernameViewModel: ListDiffable {
    
    let username: String
    
    init(username: String) {
        self.username = username
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "user" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UsernameViewModel else  { return false }
        return username == object.username
    }
    
}

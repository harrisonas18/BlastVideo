//
//  PostViewModel.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import IGListKit

final class PostViewModel: ListDiffable {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "image" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? PostViewModel else  { return false }
        return url == object.url
    }
    
}

//
//  FeedBindableSectionController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/3/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class FeedBindableSectionController: ListBindingSectionController<FeedItem>, ASListBindingSectionControllerDataSource {
    
    override init() {
        super.init()
        dataSource = self
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? FeedItem else { fatalError() }
        let results: [ListDiffable] = [
            PostViewModel(url: object.post.photoUrl!),
            UsernameViewModel(username: object.user.username!)
        ]
        return results
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> ASCellNode & ListBindable {

        switch viewModel {
        case is PostViewModel:
            return PostNode()
        default:
            return UsernameNode()
        }
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is PostViewModel: height = 250
        case is UsernameViewModel: height = 35
        default: height = 55
        }
        return CGSize(width: width, height: height)
    }
    
    
}

//
//  PostSectionController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/31/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import IGListKit

class PostSectionController: ListSectionController {
    fileprivate var diffingQueue: DispatchQueue {
        let queue = DispatchQueue(label: "ASCollectionSectionController.diffingQueue")
        return queue
    }
    
    var initialItemsRead: Bool = false
    
    var items: [Post] = [Post]()
    
    fileprivate var pendingItmes: [Post] = [Post]()
    
    override func numberOfItems() -> Int {
        if !initialItemsRead {
            pendingItmes = items
            initialItemsRead = true
        }
        return items.count;
    }
    
    func setItmes(newItems: [Post], animated: Bool, completion: (() -> ())? = nil) {
        if !initialItemsRead {
            items = newItems
            guard let completion = completion else { return  }
            completion()
        }
        
        let wasEmpty = self.items.count == 0
        
        self.diffingQueue.async {
            let result = DiffUtility.diff(originalItems: self.pendingItmes, newItems: newItems)
            self.pendingItmes = newItems
            DispatchQueue.main.async {
                if let ctx = self.collectionContext {
                    ctx.performBatch(animated: animated, updates: { bactchContext in
                        bactchContext.insert(in: self, at: result.inserts)
                        bactchContext.delete(in: self, at: result.deletes)
                        self.items = newItems;
                    }, completion: { (finished) in
                        if let completion = completion {
                            completion()
                        }
                        
                        if wasEmpty {
                            let adapter = ctx as! ListAdapter
                            adapter.performUpdates(animated: false, completion: nil)
                        }
                        
                    })
                }
            }
        }
    }
    
}

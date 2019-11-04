//
//  ASTableNodeExtension.swift
//  DeepDiffDemo
//
//  Created by Gungor Basa on 26.02.2018.
//  Copyright © 2018 onmyway133. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff

extension ASCollectionNode {
  
  /// Animate reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - section: The section that all calculated IndexPath belong
  ///   - insertionAnimation: The animation for insert rows
  ///   - deletionAnimation: The animation for delete rows
  ///   - replacementAnimation: The animation for reload rows
  ///   - completion: Called when operation completes
  public func reload<T: DiffAware>(
    changes: [Change<T>],
    section: Int = 0,
    completion: @escaping (Bool) -> Void) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    performBatchUpdates({
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
    }, completion: completion)
    
    changesWithIndexPath.replaces.executeIfPresent {
      self.reloadItems(at: $0)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
        deleteItems(at: $0)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
        insertItems(at: $0)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveRow(at: move.from, to: move.to)
      }
    }
  }
}


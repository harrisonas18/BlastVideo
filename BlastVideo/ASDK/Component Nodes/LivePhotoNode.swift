//
//  LivePhotoNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/8/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import PhotosUI

class LivePhotoNode: ASDisplayNode {
    
    var livePhoto: PHLivePhoto?
    
    var photoNode: PHLivePhotoView? {
        return self.view as? PHLivePhotoView
    }
    
    init(height: CGFloat, width: CGFloat) {
        super.init()
        self.setViewBlock({
            let photoView: PHLivePhotoView = .init(frame: CGRect(x: 0, y: 0, width: width, height: height))
            photoView.livePhoto = self.livePhoto
            return photoView
        })
        self.style.height = .init(unit: .points, value: height)
        self.style.width = .init(unit: .points, value: width)

    }
    
    func loadPhoto(post: Post) {
        StorageCacheController.shared.retrieveLivePhoto(post: post) { (livePhoto) in
            DispatchQueue.main.async {
                self.livePhoto = livePhoto
            }
        }
    }
    
}

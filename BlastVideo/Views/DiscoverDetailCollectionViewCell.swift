//
//  DiscoverDetailCollectionViewCell.swift
//  VideoAppLatestUpdate
//
//  Created by Harrison Senesac on 8/2/18.
//  Copyright © 2018 The Zero2Launch Team. All rights reserved.
//

import UIKit

class DiscoverDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var post: Post? {
        didSet {
            //updateView()
        }
    }
    
//    func updateView() {
//        if let photoUrlString = post?.photoUrl {
//            let photoUrl = URL(string: photoUrlString)
//            let placeHolderImage = UIImage(imageLiteralResourceName: "placeholder-photo")
//            photo.sd_setImage(with: photoUrl, placeholderImage: placeHolderImage)
//        }
//    }
}

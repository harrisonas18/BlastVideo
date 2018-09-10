//
//  VideoCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func  setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PostCell: VideoCell {
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            thumbnailImageView.sd_setImage(with: photoUrl)
        }
        
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "play-button1")
        imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    override func setupViews() {
        addSubview(thumbnailImageView)
        
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true;
        thumbnailImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true;
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true;
        thumbnailImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true;
        
        
    }
}

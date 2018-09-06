//
//  VideoCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class CustomeCell: UICollectionViewCell {
    
    
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

class VideoCell: CustomeCell {
    
    var video: Video? {
        didSet {
            thumbnailImageView.backgroundColor = .blue
            
        }
    }
    
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "play-button1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    private var allConstraints: [NSLayoutConstraint] = []
    
    override func setupViews() {
        addSubview(thumbnailImageView)

        
        let views: [String: Any] = [
            "thumbnailImageView": thumbnailImageView,]
        
        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[thumbnailImageView]-]",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint
        
        let imageHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[thumbnailImageView]-]",
            metrics: nil,
            views: views)
        allConstraints += imageHorizontalConstraint
        
        NSLayoutConstraint.activate(allConstraints)
        
    }
}

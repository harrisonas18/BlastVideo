//
//  HashtagCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

class HashtagSearchCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5.0
        iv.clipsToBounds = true
        return iv
    }()
    
    let hashtagLabel: UILabel = {
        let label = UILabel()
        label.text = "#hashtag"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1.0
        addSubview(photoImageView)
        photoImageView.addSubview(hashtagLabel)
        
        NSLayoutConstraint.activate([
          photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
          photoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
          photoImageView.heightAnchor.constraint(equalToConstant: 105.0),
          photoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
          hashtagLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
          hashtagLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
          hashtagLabel.heightAnchor.constraint(equalToConstant: 45.0),
          hashtagLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
    }
    
    func loadImages(hashtag: String){
        Api.HashTag.getHashtagPosts(hashtag: hashtag, limit: 1) { (posts) in
            DispatchQueue.main.async {
                let source = URL(string: posts[0].0.photoUrl!)
                self.photoImageView.kf.setImage(with: source) 
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

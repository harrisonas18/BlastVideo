//
//  PostCell.swift
//  
//
//  Created by Harrison Senesac on 9/11/18.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Post? {
        didSet {
            setupThumbnailImage()
            
        }
    }
    
    var user: UserObject? {
        didSet {
            setUpUserInfo()
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = post?.photoUrl {
            let photoUrl = URL(string: thumbnailImageUrl)
            let placeHolderImage = UIImage(imageLiteralResourceName: "UploadIcon")
            thumbnailImageView.sd_setImage(with: photoUrl, placeholderImage: placeHolderImage)
        }
        
    }
    
    func setUpUserInfo() {
        if let profileImageUrl = user?.profileImageUrl {
            let photoUrl = URL(string: profileImageUrl)
            let placeHolderImage = UIImage(imageLiteralResourceName: "UploadIcon")
            profileIV.sd_setImage(with: photoUrl, placeholderImage: placeHolderImage)
        }
    }
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let profileIV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
//        imageView.backgroundColor = .blue
        return imageView
    }()
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(profileIV)
        
        thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        
        profileIV.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 10).isActive = true
        profileIV.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -10).isActive = true
        profileIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
}











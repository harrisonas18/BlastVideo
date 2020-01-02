//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 3/30/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import PhotosUI

class PhotoSelectorCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected
            {
                //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)
                selectedView.isHidden = false
            }
            else
            {
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
                selectedView.isHidden = true
            }
        }
    }

    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        let color = UIColor.white.withAlphaComponent(0.2)
        view.backgroundColor = color
        return view
    }()

//    let selectedImage: UIView = {
//        let view = UIView()
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.backgroundColor = UIColor(red: 27.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
//        view.layer.cornerRadius = 12.5
//        return view
//    }()
    
    let selectedImage: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        //view.layer.backgroundColor = UIColor(red: 27.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        view.layer.cornerRadius = 12.5
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "selectedIcon")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        photoImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 1, height: self.frame.height - 1)
        addSubview(photoImageView)
        selectedView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.width , height: photoImageView.frame.height )
        photoImageView.addSubview(selectedView)
        selectedImage.frame = CGRect(x: 2, y: selectedView.frame.maxY - 27, width: 25, height: 25)
        selectedView.insertSubview(selectedImage, at: 1)
        selectedView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

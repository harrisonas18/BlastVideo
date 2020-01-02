//
//  File.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var user = UserObject()
    let userImg = UIImageView(frame: CGRect(x: 5, y: 2.5, width: 50, height: 50))
    let usernameLabel = UILabel(frame: CGRect(x: 60, y: 15, width: 125, height: 25))
    let userRealName = UILabel(frame: CGRect(x: 60, y: 15, width: 125, height: 25))
    let followButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userImg.backgroundColor = UIColor.lightGray
        userImg.contentMode = .scaleAspectFill
        userImg.layer.cornerRadius = 25.0
        userImg.clipsToBounds = true
        
        followButton.setTitle("Unfollow", for: .selected)
        followButton.backgroundColor = .systemPink
        followButton.setTitleColor(.white, for: .selected)
        
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .black
        followButton.setTitleColor(.white, for: .normal)
        
        followButton.layer.cornerRadius = 5.0
        followButton.clipsToBounds = true
        followButton.isUserInteractionEnabled = true
        followButton.addTarget(self, action: #selector(followSelected), for: .touchUpInside)
        followButton.frame = CGRect(x: contentView.frame.maxX-35, y: 7.5, width: 75, height: 40)

        contentView.addSubview(userImg)
        contentView.addSubview(usernameLabel)
        //contentView.addSubview(followButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isFollowSelected : Bool = false
    @objc func followSelected(){
        print("Follow selected")
        isFollowSelected.toggle()
        followButton.isSelected = isSelected
        if isFollowSelected == true {
            print("Unfollow")
            followButton.setTitle("Unfollow", for: .selected)
            followButton.backgroundColor = .systemPink
            followButton.setTitleColor(.white, for: .selected)
            Api.Follow.followAction(withUser: user.id!)
        } else {
            print("Follow")
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .black
            followButton.setTitleColor(.white, for: .normal)
            Api.Follow.unFollowAction(withUser: user.id!)
        }
    }
    
    
}

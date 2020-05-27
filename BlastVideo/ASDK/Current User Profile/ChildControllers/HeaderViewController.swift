//
//  HeaderViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var bannerInitialCenterY: CGFloat!
    var stickyBanner = true
    var user: UserObject? {
        didSet{
            if let name = self.user?.realName {
                //self.fullName.text = name
            } else {
                //self.fullName.text = "Name"
            }
            //self.username.text = self.user?.bio ?? "Bio"
            let url = URL(string: self.user?.profileImageUrl ?? "")
            //self.userImageView.kf.setImage(with: url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Api.User.observeCurrentUser { (user) in
            self.user = user
            currentUserGlobal = user
        }
    }
    let placeholder = UIImage(named: "ProfilePlaceholder")
    //TODO: Add checks to make sure information is available
    //Add didset to user object to reset header when a new user object is downloaded and displayed
    //Also add loading animation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = self.user?.realName {
            self.fullName.text = name
        } else {
            self.fullName.text = "Harrison Senesac"
        }
        self.username.text = self.user?.bio ?? "Livin' in VT"
        let url = URL(string: self.user?.profileImageUrl ?? "")
        //self.userImageView.kf.setImage(with: url)
        
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.kf.setImage(with: url, placeholder: placeholder)
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        //imgContainer.layer.cornerRadius = 37
        //userImageView.layer.borderWidth = 8.0
        //userImageView.layer.borderColor = UIColor.white.cgColor
        
        let firstColor = UIColor(red: 238/255.0, green: 99/255.0, blue: 82/255.0, alpha: 1.0)
        let secondColor = UIColor(red: 89/255.0, green: 205/255.0, blue: 144/255.0, alpha: 1.0)
        let thirdColor = UIColor(red: 63/255.0, green: 167/255.0, blue: 214/255.0, alpha: 1.0)
        let fourthColor = UIColor(red: 250/255.0, green: 192/255.0, blue: 94/255.0, alpha: 1.0)
        //let fifthColor = UIColor(red: 247/255.0, green: 157/255.0, blue: 132/255.0, alpha: 1.0)
        
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 39
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let view2 = UIView()
        view2.backgroundColor = .clear
        view2.layer.borderColor = UIColor.white.cgColor
        view2.layer.borderWidth = 4.0
        view2.layer.cornerRadius = 39
        view2.translatesAutoresizingMaskIntoConstraints = false
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
        gradient.colors = [secondColor.cgColor, thirdColor.cgColor, fourthColor.cgColor, firstColor.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 8
        shape.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        //view.layer.insertSublayer(shape, at: 99)
        
        imgContainer.insertSubview(view2, at: 88)
        imgContainer.insertSubview(view, at: 99)
        
        NSLayoutConstraint.activate([
            view2.topAnchor.constraint(equalTo: imgContainer.topAnchor, constant: -4.0),
            view2.bottomAnchor.constraint(equalTo: self.imgContainer.bottomAnchor, constant: 4.0),
            view2.leadingAnchor.constraint(equalTo: self.imgContainer.leadingAnchor, constant: -4.0),
            view2.trailingAnchor.constraint(equalTo: self.imgContainer.trailingAnchor, constant: 4.0),
            view.topAnchor.constraint(equalTo: self.imgContainer.topAnchor, constant: -4.0),
            view.bottomAnchor.constraint(equalTo: self.imgContainer.bottomAnchor, constant: 4.0),
            view.leadingAnchor.constraint(equalTo: self.imgContainer.leadingAnchor, constant: -4.0),
            view.trailingAnchor.constraint(equalTo: self.imgContainer.trailingAnchor, constant: 4.0),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: Notification.Name("refreshProfile"), object: nil)
        
    }
    
    @objc func refreshContent(){
        self.fullName.text = currentUserGlobal.realName
        self.username.text = currentUserGlobal.username
        let url = URL(string: currentUserGlobal.profileImageUrl ?? "")
        //self.userImageView.kf.setImage(with: url)
        
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}

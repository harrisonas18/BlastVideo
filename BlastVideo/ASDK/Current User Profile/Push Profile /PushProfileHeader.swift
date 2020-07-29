//
//  PushProfileHeader.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import Kingfisher

class PushProfileHeader: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var divider: UIView!
    
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBAction func followButtonTouched(_ sender: Any) {
        followButtonTapped()
    }
    var bannerInitialCenterY: CGFloat!
    var stickyBanner = true
    var user: UserObject?
    var isFollowing: Bool?
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Checks to see if the current user follows the user with the corresponding user id
        //This sets the state for the follow button
        Api.Follow.isFollowing(userId: user?.id! ?? "") { (isFollowing) in
            if isFollowing {
                self.isFollowing = true
                self.configureUnFollowButton()
            } else {
                self.isFollowing = false
                self.configureFollowButton()
            }
        }
        self.followButton.isUserInteractionEnabled = false
        //self.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)

        
        if let name = self.user?.realName {
            self.fullName.text = name
        } else {
            self.fullName.text = ""
        }
        self.username.text = self.user?.bio ?? ""
        let url = URL(string: self.user?.profileImageUrl ?? "")
        //self.userImageView.kf.setImage(with: url)
        let placeholder = UIImage(named: "ProfilePlaceholder")
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.kf.setImage(with: url, placeholder: placeholder)
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        divider.layer.cornerRadius = divider.frame.height / 2
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
        
    }
    
    //Configures follow Button
    //Triggered when unfollow button is tapped
    func configureFollowButton(){
        UIView.animate(withDuration: 0.3) {
            self.followButton.setTitleColor(UIColor.init(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0), for: .normal)
            self.followButton.setTitle("follow", for: .normal)
        }
        self.followButton.isUserInteractionEnabled = true
    }
    //Configures unfollow Button
    //Triggered when follow button is tapped
    func configureUnFollowButton(){
        UIView.animate(withDuration: 0.3) {
            self.followButton.setTitleColor(UIColor.init(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0), for: .normal)
            self.followButton.setTitle("unfollow", for: .normal)
        }
        self.followButton.isUserInteractionEnabled = true
    }
    
    
    //Configures unfollow Button when follow tapped
    @objc func followButtonTapped(){
        
        if let isFollowing = self.isFollowing {
            if isFollowing {
                //changes from unfollow to follow
                print("isFollowing",isFollowing)
                Api.Follow.unFollowAction(withUser: user!.id!)
                configureFollowButton()
                user!.isFollowing! = false
                self.isFollowing = false
                print("isFollowing",isFollowing)
            } else {
                //changes from follow to unfollow
                print("isFollowing",isFollowing)
                Api.Follow.followAction(withUser: user!.id!)
                configureUnFollowButton()
                user!.isFollowing! = true
                self.isFollowing = true
                print("isFollowing",isFollowing)

            }
        } else {
            print("Follow button tapped")
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func adjustBannerView(with progress: CGFloat, headerHeight: ClosedRange<CGFloat>){
        
        let y = progress * (headerHeight.upperBound - headerHeight.lowerBound)
        let topLimit = bannerImageView.frame.height - headerHeight.lowerBound
        if y > topLimit{
            bannerImageView.center.y = bannerInitialCenterY + y - topLimit
            if stickyBanner{
                self.stickyBanner = false
                self.view.bringSubviewToFront(bannerImageView)
            }
        } else {
            let scale = min(1, (1-progress))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyBanner {
                self.stickyBanner = true
                self.view.sendSubviewToBack(bannerImageView)
            }
        }
    }
}

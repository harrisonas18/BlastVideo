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
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var bannerInitialCenterY: CGFloat!
    var stickyBanner = true
    var user: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Api.User.observeUser(withId: user?.id ?? "") { (user) in
            self.fullName.text = user.username ?? "Full Name"
            self.username.text = user.username ?? "Username"
            let url = URL(string: user.profileImageUrl ?? "")
            self.userImageView.kf.setImage(with: url)
            
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        
        let firstColor = UIColor(red: 238/255.0, green: 99/255.0, blue: 82/255.0, alpha: 1.0)
        let secondColor = UIColor(red: 89/255.0, green: 205/255.0, blue: 144/255.0, alpha: 1.0)
        let thirdColor = UIColor(red: 63/255.0, green: 167/255.0, blue: 214/255.0, alpha: 1.0)
        let fourthColor = UIColor(red: 250/255.0, green: 192/255.0, blue: 94/255.0, alpha: 1.0)
        //let fifthColor = UIColor(red: 247/255.0, green: 157/255.0, blue: 132/255.0, alpha: 1.0)
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: userImageView.frame.size)
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
        gradient.colors = [secondColor.cgColor, thirdColor.cgColor, fourthColor.cgColor, firstColor.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 4
        shape.path = UIBezierPath(roundedRect: userImageView.bounds, cornerRadius: userImageView.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        userImageView.layer.addSublayer(gradient)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        if bannerInitialCenterY == nil{
        //            bannerInitialCenterY = bannerImageView.center.y
        //        }
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

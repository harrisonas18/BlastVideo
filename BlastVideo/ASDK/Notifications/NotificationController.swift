//
//  NotificationController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/28/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

//Convert to Texture
//Add table view
//Create Notification Cell

class NotificationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Notifications", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
//        navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refreshIcon"), style: .plain, target: self, action: #selector(pushSettings))
//        rightButton.tintColor = .black
//        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    
    
    
    
}

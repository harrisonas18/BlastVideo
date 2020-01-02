//
//  AboutController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class AboutController: ASViewController<AboutNode> {
    
    init() {
        super.init(node: AboutNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AboutController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Feed", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refreshIcon"), style: .plain, target: self, action: #selector(pushSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func pushSettings(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
    }
    
}

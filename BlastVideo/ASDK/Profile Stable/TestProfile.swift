//
//  TestProfile.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

let kGoTopNotificationName: String = "goTop"
let kLeaveTopNotificationName: String = "leaveTop"

class TestProfile: UIViewController {

    
    var pageVC: PageControllerFooterMore
    var tableView : GestureTableView
    
    var isTopIsCanNotMoveTabView : Bool
    var isTopIsCanNotMoveTabViewPre: Bool
    var canScroll: Bool
    
    var pan: UIGestureRecognizer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addSubview(self.tableView)
        //_canScroll = true
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg), name: NSNotification.Name(rawValue: kLeaveTopNotificationName), object: nil)
    }
    
    @objc func acceptMsg(notification: NSNotification){
        if notification.name.rawValue == kLeaveTopNotificationName {
            //_canScroll = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestProfile: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let pageTabOffsetY = 
    }
}
extension TestProfile: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}




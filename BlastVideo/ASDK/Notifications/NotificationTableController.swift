//
//  NotificationTableController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/28/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NotificationTableController: ASViewController<ASTableNode> {
    
    init() {
        let table = ASTableNode(style: .plain)
        super.init(node: table)
        self.node.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotificationTableController: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASCellNode()
        return cell
    }
    
}



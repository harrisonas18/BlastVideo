//
//  GestureTableView.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit


class GestureTableView: UITableView, UIGestureRecognizerDelegate {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (self.tableHeaderView != nil) && self.tableHeaderView!.frame.contains(point) {
            return false
        }
        return super.point(inside: point, with: event)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}

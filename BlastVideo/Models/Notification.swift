//
//  Notification.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseAuth

class PushNotification {
    var from: String?
    var objectId: String?
    var type: String?
    var timestamp: Int?
    var id: String?
}

extension PushNotification {
    static func transform(dict: [String: Any], key: String) -> PushNotification {
        let notification = PushNotification()
        notification.id = key
        notification.objectId = dict["objectId"] as? String
        notification.type = dict["type"] as? String
        notification.timestamp = dict["timestamp"] as? Int
        notification.from = dict["from"] as? String
        return notification
    }
}
 

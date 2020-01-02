//
//  NotificationApi.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseDatabase
class NotificationApi {
    var REF_NOTIFICATION = Database.database().reference().child("notification")
    
    func observeNotification(withId  id: String, completion: @escaping (PushNotification) -> Void) {
        REF_NOTIFICATION.child(id).observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newNoti = PushNotification.transform(dict: dict, key: snapshot.key)
                completion(newNoti)
            }
        })
    }

}

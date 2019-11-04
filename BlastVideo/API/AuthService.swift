//
//  AuthService.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    func signUp(username: String, email: String, password: String, completion: AuthDataResultCallback? = nil, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = authResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }

                var profileURL: String = ""
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        print("Error could not retrieve URL")
                        return
                    }
                    profileURL = downloadURL.absoluteString
                }
                
                self.setUserInfomation(profileImageUrl: profileURL , username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        }
        
    }
    
    func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    func updateUserInfor(username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
            }else {
                let uid = Auth.auth().currentUser?.uid
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    var profileURL: String = ""
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            print("Error could not retrieve URL")
                            return
                        }
                        profileURL = downloadURL.absoluteString
                    }
                    
                    self.updateDatabase(profileImageUrl: profileURL, username: username, email: email, onSuccess: onSuccess, onError: onError)
                })
            }
        })
        
        
    }
    
    
    
    func updateDatabase(profileImageUrl: String, username: String, email: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        let dict = ["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl]
        Api.User.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
            
        })
    }
    
    func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
}

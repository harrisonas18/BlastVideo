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
    
    //MARK: Sign In
    
    func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    
    
    
    //Check to see if username is taken
    //Rules - Max Character Limit: 30
    //At least two characters, no spaces
    //MARK: Verify Username
    
    func verifyUsername(username: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void){
        
        print("Username", username)
        
        let ref = Database.database().reference()
        let usersReference = ref.child("usernames").child(username.lowercased())
        
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let username = value?["username"] as? String ?? ""
            print("Value ", value)
            print("Username ", username)
          // ...
          //Check to see if username is equal to nil and return empty string
          // Else return success function
            if value == nil {
                onSuccess()
                print("Success")
            } else {
                onError("Username is taken")
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    //MARK: Sign Up
    func signUp(username: String, email: String, password: String, completion: AuthDataResultCallback? = nil, imageData: Data?, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = authResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
            
            if let data = imageData {
                storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
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
            } else {
                self.setUserInfomation(profileImageUrl: nil, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            }
            
        }
        
    }
    
    //Path to set user information - Change this database reference here if needed 
    func setUserInfomation(profileImageUrl: String?, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child("users")
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        if let url = profileImageUrl {
            changeRequest?.photoURL = URL(string: url)
            let newUserReference = usersReference.child(uid)
            newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl])
        } else {
            let newUserReference = usersReference.child(uid)
            newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email])
        }
        
        
        onSuccess()
        
        
        changeRequest?.commitChanges { (error) in
            print(error?.localizedDescription)
        }
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
    
    //Updates Users profile image
    func updateProfileImage(image: UIImage, completion: @escaping (String?) -> Void){
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
        let imageData = Data()
        
        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                completion(nil)
            }
            var profileURL: String = ""
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve URL")
                    return
                }
                profileURL = downloadURL.absoluteString
                completion(profileURL)
            }
            
        })
    }
    
    //TODO: Add update to profile here with ability to specify specific fields that need to update
    func updateProfile(profileImgURL: String?, username: String?, email: String?, realName: String?, bio: String?, FCMToken: String?, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?)->Void){
        
        var dict:[String: String] = [:]
        
        if let url = profileImgURL {
            dict.updateValue(url, forKey: "profileImageUrl")
        }
        if let username = username {
            dict.updateValue(username, forKey: "username")
        }
        if let email = email {
            dict.updateValue(email, forKey: "email")
        }
        if let realName = realName {
            dict.updateValue(realName, forKey: "realName")
        }
        if let bio = bio {
            dict.updateValue(bio, forKey: "bio")
        }
        if let FCMToken = FCMToken {
            dict.updateValue(FCMToken, forKey: "FCMToken")
        }
        
        
        
        Api.User.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
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
    
    //MARK: Log Out
    func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
}

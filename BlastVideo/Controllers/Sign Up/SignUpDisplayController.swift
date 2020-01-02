//
//  SignUpDisplayController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/26/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.

import Foundation
import AsyncDisplayKit
import NotificationBannerSwift
import FirebaseAuth

class SignUpDisplayController: ASViewController<SignUpNode> {

    let auth = Api.Auth
    var imgData = Data()
    
    
    init() {
        super.init(node: SignUpNode())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pushImagePicker), name: Notification.Name("PushImagePicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearUserPhoto), name: Notification.Name("ClearUserPhoto"), object: nil)
        self.node.signUpDelegate = self
    }
    
    @objc func clearUserPhoto(){
        node.profImageBack.image = nil
        node.profImage.isHidden = false
    }
    
    @objc func pushImagePicker(){
        ImagePickerManager().pickImage(self) { (image) in
            self.node.profImage.isHidden = true
            self.node.profImageBack.image = image
            
            self.imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height *      widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

extension SignUpDisplayController: SignUpInfoDelegate {
    func getSignUpInfo(username: String, email: String, password: String) {
        Api.Auth.signUp(username: username, email: email, password: password, imageData: self.imgData, onSuccess: {
            let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Sign Up Succesful", attributes: [:]), style: .success, colors: nil)
            success.show()
            self.navigationController?.popViewController(animated: true)
        }, onError: { (error) in
            let alert = UIAlertController(title: "Error", message: "There was an error signing up. Please Try again Later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;

    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let clearAction = UIAlertAction(title: "Clear Photo", style: .default){
            UIAlertAction in
            self.clearPhoto()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            print("No camera")
            
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    func clearPhoto(){
        alert.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClearUserPhoto"), object: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // For Swift 4.2
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:     [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           guard let image = info[.originalImage] as? UIImage else {
           fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
      }
      pickImageCallback?(image)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}

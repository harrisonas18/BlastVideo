//
//  LivePhotoController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/6/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//



import UIKit
import MobileCoreServices
import Photos
import PhotosUI
import AVKit
import ImageIO

func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    default:
        fatalError("Uknown Error - Photo Library Access")
        break
    }
}


class LivePhotoViewController: UIViewController {
    
    typealias LivePhotoResources = (pairedImage: URL, pairedVideo: URL)
    
    @IBOutlet var livePhotoView : UIView!
    var looper : AVPlayerLooper!
    var selectedImage: UIImage?
    var videoURL: URL?
    var photoURL: URL?
    var livePhoto: PHLivePhoto?
    let options = PHLivePhotoBadgeOptions(arrayLiteral: .overContent)
    var badgeImage : UIImage?
    var badgeImageView : UIImageView?
    var badgeBaseView = UIView(frame: CGRect(x: 8, y: 8, width: 75 , height: 50))
    let label = UILabel()
    var stackView : UIStackView?
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if self.traitCollection.userInterfaceIdiom == .pad {
            return .all
        }
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        livePhotoView.layer.borderWidth = 1.0
        livePhotoView.layer.borderColor = UIColor.lightGray.cgColor
        setUpBadgeView()
        
    }
    
    func setUpBadgeView() {
        badgeBaseView = UIView(frame: CGRect(x: 8, y: 8, width: 75 , height: 40))
        badgeImageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 50, height: 50))
        
        label.attributedText = NSAttributedString(string: "LIVE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let white = UIColor.white
        let opaque = white.withAlphaComponent(0.75)
        badgeBaseView.backgroundColor = opaque
        badgeBaseView.layer.cornerRadius = 5.0
        
        badgeImage = PHLivePhotoView.livePhotoBadgeImage(options: options)
        badgeImageView?.contentMode = .scaleAspectFill
        badgeImageView?.image = badgeImage
        
        stackView = UIStackView(arrangedSubviews: [badgeImageView!, label])
        stackView?.frame = CGRect(x: 0, y: 0, width: 75, height: 40)
        stackView?.axis = .horizontal
        stackView?.alignment = .center
        stackView?.distribution = .fillProportionally
        
        badgeBaseView.addSubview(stackView!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func uploadMediaTouched(_ sender: Any) {
        view.endEditing(true)
        if let profileImg = self.selectedImage, let _ = profileImg.jpegData(compressionQuality: 1.0) {
            _ = profileImg.size.width / profileImg.size.height
            //HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoURL, ratio: Float(ratio), caption: "", onSuccess: {
//                self.clearAll()
//                self.tabBarController?.selectedIndex = 0
//            })

        } else {
            print("Error")
            let alert = UIAlertController(title: "Error", message:"Couldn't Upload Post", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func doPick (_ sender: Any!) {
        
        // according to the video, in iOS 11 no authorization is required,
        // because everything is happening out-of-process
        // but they haven't stated this accurately;
        // it works to get the photo, but if you want important stuff like the PHAsset and the media URL,
        // you still need authorization
        
        checkForPhotoLibraryAccess {
            
            // horrible Moments interface
            //let src = UIImagePickerController.SourceType.savedPhotosAlbum
            let src = UIImagePickerController.SourceType.photoLibrary
            
            guard UIImagePickerController.isSourceTypeAvailable(src)
                else { print("alas"); return }
            
            guard UIImagePickerController.availableMediaTypes(for: src) != nil
                else { print("no available types"); return }
            
            let picker = UIImagePickerController()
            
            picker.sourceType = src
            // if you don't explicitly include live photos, you won't get any live photos as live photos
//            picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String, kUTTypeMovie as String]
            picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
            // picker.mediaTypes = arr
            picker.delegate = self
            // new in iOS 11
            picker.videoExportPreset = AVAssetExportPreset640x480 // for example
            
            picker.allowsEditing = false // try true
            
            // this will automatically be fullscreen on phone and pad, looks fine
            // note that for .photoLibrary, iPhone app must permit portrait orientation
            // if we want a popover, on pad, we can do that; just uncomment next line
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true)
            if let pop = picker.popoverPresentationController {
                let v = sender as! UIView
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
            
        }
        
    }
    
    @objc func segueToEdit(){
        print("Next Button Pressed")
//        let editController = EditPhotoViewController(livePhoto: livePhoto!, displayPhoto: livePhoto!, tmpVideo: )
//        self.navigationController?.pushViewController(editController, animated: true)
    }
}

extension LivePhotoViewController {
    func setUpNavBar() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        button.addTarget(self, action: #selector(segueToEdit), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.blue, for: .normal)
        
        let rightBarItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.isTranslucent = false

    }
    

}

// if we do nothing about cancel, cancels automatically
// if we do nothing about what was chosen, cancel automatically but of course now we have no access

// interesting problem is that we have no control over permitted orientations of picker
// that's why I subclass for the sake of the example

extension LivePhotoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // this has no effect
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //
        let asset = info[.phAsset] as? PHAsset
        // types are 0 for unsupported, then image, imageAnimated, livePhoto, video, videoLooping
        let live = info[.livePhoto] as? PHLivePhoto
        self.dismiss(animated:true) {
            if let style = asset?.playbackStyle {
                switch style {
                
                case .livePhoto:
                    if live != nil {
                        self.showLivePhoto(live!)
                        self.livePhoto = live
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        let resources = PHAssetResource.assetResources(for: live!)
//                        LivePhoto.extractResources(from: live!, completion: { (resources) in
//                            self.photoURL = resources?.pairedImage
//                            self.videoURL = resources?.pairedVideo
//                            if let keyPhotoPath = self.photoURL {
//                                if FileManager.default.fileExists(atPath: keyPhotoPath.path) {
//                                    guard let keyPhotoImage = UIImage(contentsOfFile: keyPhotoPath.path) else {
//                                        return
//                                    }
//                                    self.selectedImage = keyPhotoImage
//                                }
//                            }
//                        })
                    }
                default:
                    let alert = UIAlertController(title: "Error", message:"You Must Choose a Live Photo", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    func clearAll() {
        if self.children.count > 0 {
            let av = self.children[0] as! AVPlayerViewController
            av.willMove(toParent: nil)
            av.view.removeFromSuperview()
            av.removeFromParent()
        }
        self.livePhotoView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func showLivePhoto(_ ph:PHLivePhoto) {
        self.clearAll()
        livePhotoView.layer.borderWidth = 0
        let v = PHLivePhotoView(frame: self.livePhotoView.bounds)
        v.contentMode = .scaleAspectFit
        v.livePhoto = ph
        self.livePhotoView.addSubview(v)
        v.addSubview(badgeBaseView)
    }
    
    
    
    func pickUpMetadata(_ imurl:URL?) {
        let src = CGImageSourceCreateWithURL(imurl! as CFURL, nil)!
        let d = CGImageSourceCopyPropertiesAtIndex(src,0,nil) as! [AnyHashable:Any]
        print(d)
        
    }
}


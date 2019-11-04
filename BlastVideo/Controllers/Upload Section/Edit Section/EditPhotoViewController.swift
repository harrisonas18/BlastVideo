//
//  EditPhotoViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/7/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import NextLevelSessionExporter


class EditPhotoViewController: ASViewController<EditPhotoNode> {
    
    // MARK: - Variables
    let livePhoto: PHLivePhoto
    var selectedImage: UIImage?
    var videoURL: URL?
    var photoURL: URL?
    var editPhotoDelegate: EditPhotoDelegate?
    var captionText: String? = nil
    
    var queue = DispatchQueue(label: "com.liveme.editPhotoQueue.serial")
    
    init(livePhoto: PHLivePhoto, displayPhoto: PHLivePhoto) {
        self.livePhoto = livePhoto
        super.init(node: EditPhotoNode(livePhoto: displayPhoto))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.hideKeyboardWhenTappedAround()
        self.node.delegate = self
        queue.async {
            LivePhoto.extractResources(from: self.livePhoto, completion: { (resources) in
                print("Resources extracted")
                self.photoURL = resources?.pairedImage
                self.videoURL = resources?.pairedVideo
                
            })
        }
    }
    
    
}

extension EditPhotoViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Post", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadPressed))
        rightBarButtonItem.tintColor = UIColor.textColor()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    //Resizes image to use less memory uploading and downloading
    //TODO: -Add capability to export 1x 2x 3x images for different devices so images fit correctly
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
    
    //TODO: -Test to see how different settings affect file size
    //      -Resize video so it fits cell
    //Compresses video to use less data while uploading
    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL) -> Void) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHEVC1920x1080)
        let data = NSData(contentsOf: inputURL)!
        print((Double(data.length) / 1048576.0), " mb")
        
        exportSession!.outputURL = outputURL
        exportSession!.outputFileType = AVFileType.mov
        //exportSession!.shouldOptimizeForNetworkUse = true
        
        exportSession!.exportAsynchronously { () -> Void in
            let data = NSData(contentsOf: outputURL)!
            print((Double(data.length) / 1048576.0), " mb")
            completion(outputURL)
            
        }
        
    }

    
    //TODO: Refactor to use upload service and not helper service
    @objc func uploadPressed() {
        view.endEditing(true)
            if let keyPhotoPath = self.photoURL {
                if FileManager.default.fileExists(atPath: keyPhotoPath.path) {
                    guard let keyPhotoImage = UIImage(contentsOfFile: keyPhotoPath.path) else {
                        return
                    }
                    self.selectedImage = keyPhotoImage
                    if let profileImg = self.selectedImage {
                        let scaledImage = resizeImage(image: profileImg, targetSize: CGSize(width: 543.75, height: 725))
                        let imgData = scaledImage.jpegData(compressionQuality: 0.5)
                        let ratio = profileImg.size.width / profileImg.size.height
                        print(NSTemporaryDirectory() + "video.mp4")
                        DispatchQueue.main.async {
                            GradientLoadingBar.shared.fadeIn()
                        }
                        
                        let asset = AVURLAsset(url: self.videoURL!, options: nil)
                        let data = NSData(contentsOf: self.videoURL!)!
                        print((Double(data.length) / 1048576.0), " mb")
                        let exporter = NextLevelSessionExporter(withAsset: asset)
                        exporter.outputFileType = AVFileType.mp4
                        
                        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                            .appendingPathComponent(ProcessInfo().globallyUniqueString)
                            .appendingPathExtension("mp4")
                        exporter.outputURL = tmpURL
                        
                        let compressionDict: [String: Any] = [
                            AVVideoAverageBitRateKey: NSNumber(integerLiteral: 5000000),
                            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel as String,
                        ]
                        //AVVideoProfileLevelH264HighAutoLevel
                        exporter.videoOutputConfiguration = [
                            AVVideoCodecKey: AVVideoCodecType.h264,
                            AVVideoWidthKey: NSNumber(integerLiteral: 1920),
                            AVVideoHeightKey: NSNumber(integerLiteral: 1080),
                            AVVideoCompressionPropertiesKey: compressionDict
                        ]
                        exporter.audioOutputConfiguration = [
                            AVFormatIDKey: kAudioFormatMPEG4AAC,
                            AVEncoderBitRateKey: NSNumber(integerLiteral: 128000),
                            AVNumberOfChannelsKey: NSNumber(integerLiteral: 2),
                            AVSampleRateKey: NSNumber(value: Float(44100))
                        ]
                        
                        exporter.export(progressHandler: { (progress) in
                            print(progress)
                        }, completionHandler: { result in
                            switch result {
                            case .success(let status):
                                switch status {
                                case .completed:
                                    let data = NSData(contentsOf: tmpURL)!
                                    print((Double(data.length) / 1048576.0), " mb")
                                    HelperService.uploadDataToServer(data: imgData!, videoUrl: tmpURL, ratio: Float(ratio), caption: self.captionText!, onSuccess: {
                                        
                                        DispatchQueue.main.async {
                                            GradientLoadingBar.shared.fadeOut()
                                            let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Upload Succesful", attributes: [:]), style: .success, colors: nil)
                                            success.show()
                                        }
                                        
                                    })
                                    break
                                default:
                                    print("NextLevelSessionExporter, did not complete")
                                    break
                                }
                                break
                            case .failure(let error):
                                print("NextLevelSessionExporter, failed to export \(error)")
                                break
                            }
                        })
                         
                    } else {
                        print("upload failed")
                        DispatchQueue.main.async {
                            GradientLoadingBar.shared.fadeOut()
                            let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Upload Failed", attributes: [:]), style: .danger, colors: nil)
                            success.show()
                        }
                    }


                } else {
                        DispatchQueue.main.async {
                            GradientLoadingBar.shared.fadeOut()
                            let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Upload Failed", attributes: [:]), style: .danger, colors: nil)
                            error.show()
                        }
                    }
            }
    }
    
}

extension EditPhotoViewController: EditPhotoDelegate {
    func getCaptionText(text: String) {
        captionText = text
    }
}

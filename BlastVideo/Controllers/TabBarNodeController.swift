//
//  TabBarNodeController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/3/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
import MobileCoreServices
import Photos
import AVKit
import ImageIO
import Firebase
import AsyncDisplayKit

class TabBarNodeController: UIViewController, UIScrollViewDelegate {
    
    let chooseImgButton = UIButton()
    let imgView = PHLivePhotoView()
    let scrollView = UIScrollView()
    
    var uniformTypeID = "C09A365F-D24A-497A-8EDB-D01DFC1A890C"
    
    var tmpVideoURL = URL(string: "")
    var tmpPhotoURL = URL(string: "")
    
    var photoURL: NSURL?
    var newPhotoURL: URL?
    var videoURL: NSURL?
    
    var photoDownURL: URL?
    var videoDownURL: URL?
    
    
    let videoNode = ASVideoNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //view.addSubview(imgView)
        view.addSubview(videoNode.view)
        view.addSubview(chooseImgButton)
        imgView.isUserInteractionEnabled = true
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(zoom(gesture:)))
        imgView.addGestureRecognizer(pinchMethod)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        //scrollView.addSubview(imgView)
        
        imgView.layer.cornerRadius = 11.0
        imgView.clipsToBounds = false
        imgView.layer.backgroundColor = UIColor.lightGray.cgColor

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        chooseImgButton.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        videoNode.view.translatesAutoresizingMaskIntoConstraints = false
        
        chooseImgButton.layer.cornerRadius = 5.0
        chooseImgButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        chooseImgButton.setTitle("Choose Image", for: .normal)
        chooseImgButton.setTitleColor(.white, for: .normal)
        chooseImgButton.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            videoNode.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            videoNode.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            videoNode.view.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            videoNode.view.heightAnchor.constraint(equalToConstant: 400),

            chooseImgButton.topAnchor.constraint(equalTo: videoNode.view.bottomAnchor, constant: 0),
            chooseImgButton.heightAnchor.constraint(equalToConstant: 55),
            chooseImgButton.widthAnchor.constraint(equalToConstant: 300),
            chooseImgButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

        ])
        
        photoURL = NSURL(fileURLWithPath: NSTemporaryDirectory(),isDirectory: true)
        
        newPhotoURL = URL(fileURLWithPath: NSTemporaryDirectory(),isDirectory: true)
        .appendingPathComponent(ProcessInfo().globallyUniqueString)
        .appendingPathExtension("jpeg")
        
        videoURL = NSURL(fileURLWithPath: NSTemporaryDirectory(),isDirectory: true)
        
        tmpVideoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("\(uniformTypeID)/video")
        .appendingPathExtension("mov")
              
        tmpPhotoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("\(uniformTypeID)/photo")
        .appendingPathExtension("jpeg")
        
        //download(id: uniformTypeID)
        
    }
    
    var lastScale:CGFloat!
    @objc func zoom(gesture:UIPinchGestureRecognizer) {
        if(gesture.state == .began) {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = gesture.scale
        }
        if (gesture.state == .began || gesture.state == .changed) {
        let currentScale = gesture.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
        // Constants to adjust the max/min values of zoom
        let kMaxScale:CGFloat = 2.0
        let kMinScale:CGFloat = 1.0
        var newScale = 1 -  (lastScale - gesture.scale)
        newScale = min(newScale, kMaxScale / currentScale)
        newScale = max(newScale, kMinScale / currentScale)
        let transform = (gesture.view?.transform)!.scaledBy(x: newScale, y: newScale);
        gesture.view?.transform = transform
        lastScale = gesture.scale  // Store the previous scale factor for the next pinch gesture call
      }
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    @objc func pickPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String, kUTTypeMovie as String]
        
        present(picker, animated: true, completion: nil);
    }
    
    
    //adds filter to photo supplied by the url of the tmp location
    func processPhoto(filter: String?, url: URL, completion: @escaping () -> Void){
        
        if let filter = filter {
            let context = CIContext()                                           // 1
            let filter = CIFilter(name: filter)!
            let image = CIImage(contentsOf: url)                                // 3
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            var content = UIImage(cgImage: cgImage!, scale: 1.0, orientation: .right)
            //content = (content.fixImageOrientation())!
            content = resizeImage(image: content, targetSize: CGSize(width: 543.75, height: 725))
            
            if let data = content.jpegData(compressionQuality: 0.5) {
                try? data.write(to: newPhotoURL!)
            }
            
            completion()
            
        } else {
            
            let ciImage = CIImage(contentsOf: url)// 1

            var image = UIImage(ciImage: ciImage!, scale: 1.0, orientation: .right)
            //var content = UIImage(cgImage: image, scale: 1.0, orientation: .right)
            //content = (content.fixImageOrientation())!
            image = resizeImage(image: image, targetSize: CGSize(width: 543.75, height: 725))
            
            if let data = image.jpegData(compressionQuality: 0.5) {
                print((Double(data.count) / 1048576.0), " mb")
                try? data.write(to: newPhotoURL!)
            }
            completion()
        }

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
    
    
    
    func saveAssetResource(resource: PHAssetResource, inDirectory: NSURL, buffer: NSMutableData) -> NSURL? {
      
        let maybeExt = UTTypeCopyPreferredTagWithClass(
        resource.uniformTypeIdentifier as CFString,
        kUTTagClassFilenameExtension
        )?.takeRetainedValue()

        guard let ext = maybeExt else {
            return nil
        }
        var fileUrl = inDirectory.appendingPathComponent("Adjustments")
        fileUrl = fileUrl!.appendingPathExtension(ext as String)
      
        if(!buffer.write(to: fileUrl!, atomically: true)) {
            print("Could not save resource \(resource) to filepath \(fileUrl!)")
        }
        if let path = fileUrl?.absoluteString {
            print("FilePath ", path)
            return NSURL(string: path)
        } else {
            return nil
        }
        
    }
    
    func generateFolderForLivePhotoResources() -> NSURL? {
      let photoDir = NSURL(
        // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
        fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true
      ).appendingPathComponent(NSUUID().uuidString)
      
        let fileManager = FileManager()
      // we need to specify type as ()? as otherwise the compiler generates a warning
        let success : ()? = try? fileManager.createDirectory(
            at: photoDir!,
        withIntermediateDirectories: true,
        attributes: nil
      )
      
        return success != nil ? photoDir as NSURL? : nil
    }
    
    func showLivePhoto(photoFiles: [URL]) {
        _ = PHLivePhoto.request(withResourceFileURLs: photoFiles, placeholderImage: nil, targetSize: .zero, contentMode: .aspectFill) { (livePhoto, info) in
            if livePhoto != nil {
                self.imgView.livePhoto = livePhoto
            } else {
                let error = info[PHLivePhotoInfoErrorKey] as? NSError
                if let error = error {
                    print(error)
                }
                let degraded = info[PHLivePhotoInfoIsDegradedKey] as? NSNumber
                if let degraded = degraded {
                    print(degraded)
                }
                let cancelled = info[PHLivePhotoInfoCancelledKey] as? NSNumber
                if let cancelled = cancelled {
                    print(cancelled)
                }
            }
            
        }
    }
    
    
    func upload(photoURL: URL, videoURL: URL, completion: @escaping (_ photo: URL?, _ video: URL?)->Void){
        
        let uniformTypeID = NSUUID().uuidString
        let photoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(uniformTypeID).child("photo")
        let videoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(uniformTypeID).child("video")
        
        let group = DispatchGroup()
        
        group.enter()
        _ = photoRef.putFile(from: photoURL, metadata: nil) { (meta, error) in
            guard meta != nil else {
              // Uh-oh, an error occurred!
              return
            }
            // You can also access to download URL after upload.
            photoRef.downloadURL { (url, error) in
              if let downloadURL = url {
                 self.photoDownURL = downloadURL
                group.leave()
              } else {
                group.leave()
              }
            }
        }
        
        group.enter()
        _ = videoRef.putFile(from: videoURL, metadata: nil) { (meta, error) in
            guard meta != nil else {
              // Uh-oh, an error occurred!
              return
            }

            videoRef.downloadURL { (url, error) in
              if let downloadURL = url {
                self.videoDownURL = downloadURL
                group.leave()
              } else {
                 print("No download URL")
                group.leave()
              }
            }
        }
        
        
        group.notify(queue: .main) {
            if let pURL = self.photoDownURL, let vURL = self.videoDownURL {
                completion(pURL, vURL)
            } else {
                completion(nil, nil)
            }
            
        }
        
        
    }
    
    func download(id: String) {
        // Create a reference to the file you want to download
        let videoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(id).child("video")
        let photoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(id).child("photo")
        // Download to the local filesystem
        _ = photoRef.write(toFile: self.tmpPhotoURL!) { url, error in
            if error != nil {
            // Uh-oh, an error occurred!
          } else {
            // Local file URL for "images/island.jpg" is returned
            print("Photo download success")
                _ = videoRef.write(toFile: self.tmpVideoURL!) { url, error in
                    if error != nil {
                // Uh-oh, an error occurred!
              } else {
                // Local file URL for "images/island.jpg" is returned
                print("Video download success")
                print(self.tmpPhotoURL!)
                print(self.tmpVideoURL!)
                //self.showLivePhoto(photoFiles: [self.tmpPhotoURL!, self.tmpVideoURL!])
                self.videoNode.url = self.tmpPhotoURL
                let asset = AVAsset(url: self.tmpVideoURL!)
                self.videoNode.asset = asset
                self.videoNode.shouldAutoplay = true
                self.videoNode.shouldAutorepeat = true
                self.videoNode.muted = false
                self.videoNode.play()
              }
            }
          }
        }
        
    }
    
    //Step 2: Trim Video - Trim the video of a live photo to the timerange of a bounce
    //                     For full 3 second videos: Begin at the Key photo and use .9 seconds
    // ////////////////    for the time range; from the key photo.
    //This code block declares the time range in which a movie shall be written
//    let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
//    let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
//    let timeRange = CMTimeRange(start: startTime, end: endTime)
//
//    exportSession.timeRange = timeRange
    
    
    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?
    
    class func reverseVideo(inURL: URL, outURL: URL, queue: DispatchQueue, _ completionBlock: ((Bool)->Void)?) {
        let asset = AVAsset.init(url: inURL)
        guard
            let reader = try? AVAssetReader.init(asset: asset),
            let videoTrack = asset.tracks(withMediaType: .video).first
        else {
            assert(false)
            completionBlock?(false)
            return
        }

        let width = videoTrack.naturalSize.width
        let height = videoTrack.naturalSize.height

        let readerSettings: [String : Any] = [
            String(kCVPixelBufferPixelFormatTypeKey) : kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
        ]
        let readerOutput = AVAssetReaderTrackOutput.init(track: videoTrack, outputSettings: readerSettings)
        reader.add(readerOutput)
        reader.startReading()

        var buffers = [CMSampleBuffer]()
        while let nextBuffer = readerOutput.copyNextSampleBuffer() {
            buffers.append(nextBuffer)
        }
        let status = reader.status
        reader.cancelReading()
        guard status == .completed, let firstBuffer = buffers.first else {
            assert(false)
            completionBlock?(false)
            return
        }
        let sessionStartTime = CMSampleBufferGetPresentationTimeStamp(firstBuffer)

        let writerSettings: [String:Any] = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : width,
            AVVideoHeightKey: height,
        ]
        let writerInput: AVAssetWriterInput
        if let formatDescription = videoTrack.formatDescriptions.last {
            writerInput = AVAssetWriterInput.init(mediaType: .video, outputSettings: writerSettings, sourceFormatHint: (formatDescription as! CMFormatDescription))
        } else {
            writerInput = AVAssetWriterInput.init(mediaType: .video, outputSettings: writerSettings)
        }
        writerInput.transform = videoTrack.preferredTransform
        writerInput.expectsMediaDataInRealTime = false

        guard
            let writer = try? AVAssetWriter.init(url: outURL, fileType: .mp4),
            writer.canAdd(writerInput)
        else {
            assert(false)
            completionBlock?(false)
            return
        }

        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor.init(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
        let group = DispatchGroup.init()

        group.enter()
        writer.add(writerInput)
        writer.startWriting()
        writer.startSession(atSourceTime: sessionStartTime)

        var currentSample = 0
        writerInput.requestMediaDataWhenReady(on: queue) {
            for i in currentSample..<buffers.count {
                currentSample = i
                if !writerInput.isReadyForMoreMediaData {
                    return
                }
                let presentationTime = CMSampleBufferGetPresentationTimeStamp(buffers[i])
                guard let imageBuffer = CMSampleBufferGetImageBuffer(buffers[buffers.count - i - 1]) else {
                    print("VideoWriter reverseVideo: warning, could not get imageBuffer from SampleBuffer...")
                    continue
                }
                if !pixelBufferAdaptor.append(imageBuffer, withPresentationTime: presentationTime) {
                    print("VideoWriter reverseVideo: warning, could not append imageBuffer...")
                }
            }

            // finish
            writerInput.markAsFinished()
            group.leave()
        }

        group.notify(queue: queue) {
            writer.finishWriting {
                if writer.status != .completed {
                    print("VideoWriter reverseVideo: error - \(String(describing: writer.error))")
                    completionBlock?(false)
                } else {
                    completionBlock?(true)
                }
            }
        }
    }
    
}


extension TabBarNodeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //
            let asset = info[.phAsset] as? PHAsset
            // types are 0 for unsupported, then image, imageAnimated, livePhoto, video, videoLooping
            let live = info[.livePhoto] as? PHLivePhoto
            self.dismiss(animated:true) {
                if let style = asset?.playbackStyle {
                    switch style {
                    case .imageAnimated:
                        print("Image animated")
                        break
                    case .videoLooping:
                        print("Video looping")
//                        PHCachingImageManager().requestAVAsset(forVideo: asset!, options: nil) { (avAsset, avAudio, info) in
//                            if let asset = avAsset as? AVURLAsset {
//                                DispatchQueue.main.async {
//                                    let playerItem = AVPlayerItem(url: asset.url)
//                                    let inView = UIView()
//                                    inView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//                                    self.view.addSubview(inView)
//
//                                    self.videoPlayer = AVQueuePlayer(items: [playerItem])
//                                    self.playerLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem)
//
//                                    self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
//                                    self.videoPlayerLayer!.frame = inView.bounds
//                                    self.videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//                                    inView.layer.addSublayer(self.videoPlayerLayer!)
//
//                                    self.videoPlayer?.play()
//                                    print("Video Did Begin Playing")
//                                }
//                            } else {
//                                print("Failed to return asset")
//                            }
//                        }
                        
                        if let subtype = asset?.mediaSubtypes {
                            switch subtype {
                            case .photoDepthEffect:
                                print("Photo Depth")
                                print(subtype.rawValue)
                                break
                            case .photoHDR:
                                print("Photo HDR")
                                print(subtype.rawValue)
                                break
                            case .photoLive:
                                print("Photo Live")
                                print(subtype.rawValue)
                                break
                            case .photoPanorama:
                                print("Photo Pano")
                                print(subtype.rawValue)
                                break
                            case .photoScreenshot:
                                print("Photo Pano")
                                print(subtype.rawValue)
                                break
                            case .videoHighFrameRate:
                                print("Video High Frame Rate")
                                print(subtype.rawValue)
                                break
                            case .videoStreamed:
                                print("Video Streamed")
                                print(subtype.rawValue)
                                break
                            case .videoTimelapse:
                                print("Video Timelapse")
                                print(subtype.rawValue)
                                break
                            default:
                                print("Couldn't Identify")
                                break
                            }
                        }
                        
                        let resources = PHAssetResource.assetResources(for: asset!)
                        
                        for resource in resources {
                            switch resource.type {
                            case .adjustmentBasePairedVideo:
                                print("Adjustment Base Paired Video")
                                break
                            case .adjustmentBasePhoto:
                                print("Adjustment Base Photo")
                                break
                            case .adjustmentBaseVideo:
                                print("Adjustment Base Video")
                                break
                            case .adjustmentData:
                                print("Adjustment Data")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID", resource.uniformTypeIdentifier)
                                break
                            case .alternatePhoto:
                                print("Alternate Photo")
                                break
                            case .audio:
                                print("Audio")
                                break
                            case .fullSizePairedVideo:
                                //Download video to file and play video
//                                let buffer = NSMutableData()
//                                PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
//                                    buffer.append(data)
//                                }) { (error) in
//                                    if error != nil {
//                                        print(error!)
//
//                                    } else {
//                                        print("go for save")
//                                        self.videoURL = self.saveAssetResource(resource: resource, inDirectory: self.videoURL ?? NSURL(), buffer: buffer)
//                                        DispatchQueue.main.async {
//                                            let playerItem = AVPlayerItem(url: URL(string: (self.videoURL?.absoluteString)!)!)
//                                            let inView = UIView()
//                                            inView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//                                            self.view.addSubview(inView)
//
//                                            self.videoPlayer = AVQueuePlayer(items: [playerItem])
//                                            self.playerLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem)
//
//                                            self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
//                                            self.videoPlayerLayer!.frame = inView.bounds
//                                            self.videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//                                            inView.layer.addSublayer(self.videoPlayerLayer!)
//
//                                            self.videoPlayer?.play()
//                                            print("Video Did Begin Playing")
//                                        }
//                                    }
//                                }
                                print("Full Size Paired Video")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID",resource.uniformTypeIdentifier)
                                break
                            case .fullSizePhoto:
                                print("Full Size Photo")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID",resource.uniformTypeIdentifier)
                                break
                            case .fullSizeVideo:
                                print("Full Size Video")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID",resource.uniformTypeIdentifier)
//                                let buffer = NSMutableData()
//                                PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
//                                    buffer.append(data)
//                                }) { (error) in
//                                    if error != nil {
//                                        print(error!)
//
//                                    } else {
//                                        print("go for save")
//                                        self.videoURL = self.saveAssetResource(resource: resource, inDirectory: self.videoURL ?? NSURL(), buffer: buffer)
//                                        DispatchQueue.main.async {
//                                            let playerItem = AVPlayerItem(url: URL(string: (self.videoURL?.absoluteString)!)!)
//                                            let inView = UIView()
//                                            inView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//                                            self.view.addSubview(inView)
//
//                                            self.videoPlayer = AVQueuePlayer(items: [playerItem])
//                                            self.playerLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem)
//
//                                            self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
//                                            self.videoPlayerLayer!.frame = inView.bounds
//                                            self.videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//                                            inView.layer.addSublayer(self.videoPlayerLayer!)
//
//                                            self.videoPlayer?.play()
//                                            print("Video Did Begin Playing")
//                                        }
//                                    }
//                                }
                                break
                            case .pairedVideo:
                                print("Paired Video")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID",resource.uniformTypeIdentifier)
                                let buffer = NSMutableData()
                                PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
                                    buffer.append(data)
                                }) { (error) in
                                    if error != nil {
                                        print(error!)
                                        
                                    } else {
                                        print("go for save")
                                        self.videoURL = self.saveAssetResource(resource: resource, inDirectory: self.videoURL ?? NSURL(), buffer: buffer)
                                        DispatchQueue.main.async {
                                            let playerItem = AVPlayerItem(url: URL(string: (self.videoURL?.absoluteString)!)!)
                                            let duration = Int64( ( (Float64(CMTimeGetSeconds(AVAsset(url: URL(string: (self.videoURL?.absoluteString)!)!).duration)) *  10.0) - 1) / 10.0 )
                                            let inView = UIView()
                                            inView.frame = CGRect(x: 50, y: 100, width: 300, height: 300)
                                            self.view.addSubview(inView)

                                            self.videoPlayer = AVQueuePlayer(items: [playerItem])
                                            //self.playerLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem)
                                            self.playerLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem, timeRange: CMTimeRange(start: CMTime.zero, end: CMTimeMake(value: duration/2, timescale: 1)) )
                                            
                                            self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
                                            self.videoPlayerLayer!.frame = inView.bounds
                                            self.videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill

                                            inView.layer.addSublayer(self.videoPlayerLayer!)

                                            self.videoPlayer?.play()
                                            print("Video Did Begin Playing")
                                        }
                                    }
                                }
                                break
                            case .photo:
                                print("Photo")
                                print("Asset Local ID",resource.assetLocalIdentifier)
                                print("Asset Original Filename",resource.originalFilename)
                                print("Asset Uniform Type ID",resource.uniformTypeIdentifier)
                                break
                            case .video:
                                print("Video")
                                break
                            default:
                                print("Couldn't find media type")
                                break
                            }
                        }
                           
                        break
                    case .livePhoto:
                        if live != nil {
                            if let subtype = asset?.mediaSubtypes {
                                switch subtype {
                                case .photoDepthEffect:
                                    print("Photo Depth")
                                    print(subtype.rawValue)
                                    break
                                case .photoHDR:
                                    print("Photo HDR")
                                    print(subtype.rawValue)
                                    break
                                case .photoLive:
                                    print("Photo Live")
                                    print(subtype.rawValue)
                                    break
                                case .photoPanorama:
                                    print("Photo Pano")
                                    print(subtype.rawValue)
                                    break
                                case .photoScreenshot:
                                    print("Photo Pano")
                                    print(subtype.rawValue)
                                    break
                                case .videoHighFrameRate:
                                    print("Video High Frame Rate")
                                    print(subtype.rawValue)
                                    break
                                case .videoStreamed:
                                    print("Video Streamed")
                                    print(subtype.rawValue)
                                    break
                                case .videoTimelapse:
                                    print("Video Timelapse")
                                    print(subtype.rawValue)
                                    break
                                default:
                                    print("Couldn't Identify")
                                    break
                                }
                            }
                            
                            let resources = PHAssetResource.assetResources(for: asset!)
                            
                            for resource in resources {
                                switch resource.type {
                                case .adjustmentBasePairedVideo:
                                    print("Adjustment Base Paired Video")
                                    break
                                case .adjustmentBasePhoto:
                                    print("Adjustment Base Photo")
                                    break
                                case .adjustmentBaseVideo:
                                    print("Adjustment Base Video")
                                    break
                                case .adjustmentData:
                                    print("Adjustment Data")
                                    break
                                case .alternatePhoto:
                                    print("Alternate Photo")
                                    break
                                case .audio:
                                    print("Audio")
                                    break
                                case .fullSizePairedVideo:
                                    print("Full Size Paired Video")
                                    break
                                case .fullSizePhoto:
                                    print("Full Size Photo")
                                    break
                                case .fullSizeVideo:
                                    print("Full Size Video")
                                    break
                                case .pairedVideo:
                                    print("Paired Video")
                                    break
                                case .photo:
                                    print("Photo")
                                    break
                                case .video:
                                    print("Video")
                                    break
                                default:
                                    print("Couldn't find media type")
                                    break
                                }
                            }
                            
                            let group = DispatchGroup()
                            //self.imgView.livePhoto = live
                            let photoURL = self.generateFolderForLivePhotoResources()
                            
                            let assetResources = PHAssetResource.assetResources(for: live!)
                            for resource in assetResources {
                                let buffer = NSMutableData()
                                group.enter()
                                
                                if resource.type == PHAssetResourceType.pairedVideo {
                                    PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
                                        buffer.append(data)
                                    }) { (error) in
                                        if error != nil {
                                            print(error!)
                                            group.leave()
                                        } else {
                                            print("go for save")
                                            self.videoURL = self.saveAssetResource(resource: resource, inDirectory: self.videoURL ?? NSURL(), buffer: buffer)
                                            group.leave()
                                        }
                                    }
                                }

                                if resource.type == PHAssetResourceType.photo {
                                    PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
                                        buffer.append(data)
                                    }) { (error) in
                                        if error != nil {
                                            print(error!)
                                            group.leave()
                                        } else {
                                            print("go for save")
                                            self.photoURL = self.saveAssetResource(resource: resource, inDirectory: self.photoURL ?? NSURL(), buffer: buffer )
                                            group.leave()
                                            
                                        }
                                    }
                                }
                            }
                            group.notify(queue: .main) {
                                print("show live")
                                if let pURL = self.photoURL, let vURL = self.videoURL, let npURL = self.newPhotoURL {
                                    self.showLivePhoto(photoFiles: [URL(string: pURL.absoluteString!)!, URL(string: vURL.absoluteString!)!])
                                    self.processPhoto(filter: nil, url: URL(string: pURL.absoluteString!)!) {
                                        print("New Photo URL: ",npURL.absoluteString)
                                        LivePhoto.generate(from: npURL, videoURL: URL(string: vURL.absoluteString!)!, progress: { (progress) in
                                            
                                        }) { (livePhoto, resources) in
                                            if let pairImg = resources?.pairedImage, let pairVid = resources?.pairedVideo {
                                                
                                            } else {
                                                print("No resources")
                                            }
                                        }
                                        
                                    }

                                } else {
                                    print("Could not show Live Photo")
                                }
                            }
                            
                            
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
    
    
}

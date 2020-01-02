//
//  FilterPickerController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import UIKit
import PhotosUI
import AsyncDisplayKit
import CoreImage
import NextLevelSessionExporter
import VideoToolbox

//1. Extract Resources - async
//2. Process Video (if needed) & Photo - sync
//3. Push Upload View

class FilterPickerController: ASViewController<FilterPickerNode> {
    
    let filters = ["CIPhotoEffectFade", "CIPhotoEffectChrome", "CIPhotoEffectTransfer", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal"]
    var selectedFilter: Int
    var livePhoto: PHLivePhoto
    var editedLivePhoto: PHLivePhoto?
    var asset: PHAsset
    var editingInput: PHContentEditingInput?
    var selectedImage: UIImage
    
    let identifier = Bundle.main.bundleIdentifier!
    let formatVersion = "1.0"
    var filter: String = ""
    
    var originalVideoURL = URL(string: "")
    var originalPhotoURL = URL(string: "")
    
    var processingQueue = DispatchQueue(label: "UploadProcessingQueue")
    var group = DispatchGroup()
    
    
    let tmpVideoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    .appendingPathComponent(ProcessInfo().globallyUniqueString)
    .appendingPathExtension("mov")
    
    let tmpPhotoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    .appendingPathComponent(ProcessInfo().globallyUniqueString)
    .appendingPathExtension("jpeg")
    
    init(livePhoto: PHLivePhoto, asset: PHAsset, selectedImage: UIImage) {
        self.selectedFilter = 0
        self.livePhoto = livePhoto
        self.selectedImage = selectedImage
        self.asset = asset
        super.init(node: FilterPickerNode(livePhoto: self.livePhoto))
        self.node.filterCollectionNode.delegate = self
        self.node.filterCollectionNode.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEditingInput(asset: self.asset)
        setupNavBar()
        LivePhoto.extractResources(from: livePhoto) { (resources) in
            if let videoURL = resources?.pairedVideo, let photoURL = resources?.pairedImage {
                self.originalPhotoURL = photoURL
                self.originalVideoURL = videoURL
                PostManager.shared.photoURL = self.originalPhotoURL
                PostManager.shared.videoURL = self.originalVideoURL
                self.node.livePhotoNode.photoNode?.livePhoto = self.livePhoto
                self.processPhoto(filter: nil, url: photoURL) {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Gets editing input for asset ie live photo
    func getEditingInput(asset: PHAsset) {
        print("Get input called")
        asset.requestContentEditingInput(with: .none) { (input, status) in
            print("Successfully requested asset")
            self.editingInput = input
        }
    }
    
    var context: PHLivePhotoEditingContext?
    var videoContext: CIContext?
    
    //adds filter to video supplied by tmp url
    func processVideo(filterString: String?){
        //Start loading animation here
        //user tmp photo url
        var filter: CIFilter?
        let asset = AVAsset(url: self.originalVideoURL!)
        let exporterFilter: AVAssetExportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        
        if let filString = filterString {
            filter = CIFilter(name: filString)!
            let composition = AVVideoComposition(asset: asset) { (request) in
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                filter?.setValue(source, forKey: kCIInputImageKey)
                // Crop the blurred output to the bounds of the original image
                let output = filter?.outputImage!.cropped(to: request.sourceImage.extent)

                // Provide the filter output to the composition
                request.finish(with: output!, context: nil)
            }
            exporterFilter.videoComposition = composition
            exporterFilter.outputFileType = AVFileType.mov
            exporterFilter.outputURL = self.tmpVideoURL
            
            exporterFilter.exportAsynchronously(completionHandler: {
                
                switch exporterFilter.status {
                case .cancelled:
                    print("Exporter was cancelled")
                    break
                case .completed:
                    print("Exporter has completed")
                    self.processPhoto(filter: filterString!, url: self.originalPhotoURL! ) {
                        //Stop loading and push next vc
                    }
                    break
                case .exporting:
                    print("Exporter is exporting...")
                    break
                case .failed:
                    print("Exporter has failed")
                    break
                case .waiting:
                    print("Exporter was cancelled")
                    break
                default:
                    print("Exporter: Something unknown has occurred")
                    break
                }
            })
            
        } else {
//            let exporterFilter: AVAssetExportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
//            exporterFilter.outputFileType = AVFileType.mov
//            exporterFilter.outputURL = self.tmpVideoURL
        }
        
        
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
            content = content.resizeImage(CGSize(width: 750, height: 1334))!
            
            if let data = content.jpegData(compressionQuality: 0.65) {
                try? data.write(to: tmpPhotoURL)
            }
            
            completion()
            
        } else {
            
            let ciImage = CIImage(contentsOf: url)// 1
            var image = UIImage(ciImage: ciImage!, scale: 1.0, orientation: .right)
            //var content = UIImage(cgImage: image, scale: 1.0, orientation: .right)
            //content = (content.fixImageOrientation())!
            //image = resizeImage(image: image, targetSize: CGSize(width: 543.75, height: 725))
            image = image.resizeImage(CGSize(width: 750, height: 1334))!
            if let data = image.jpegData(compressionQuality: 0.65) {
                print((Double(data.count) / 1048576.0), " mb")
                try? data.write(to: tmpPhotoURL)
            }
            completion()
        }

    }
    
    func saveEdit(filter: String, completion: @escaping () -> Void) {
        processVideo(filterString: filter)
        completion()
    }
    
    func processLivePhoto(input: PHContentEditingInput, inputFilter: String) {
        print("Begin")
        self.filter = inputFilter
        context = PHLivePhotoEditingContext(livePhotoEditingInput: self.editingInput!)
        context?.frameProcessor = { frame, _ in
            return frame.image.applyingFilter(inputFilter, parameters: [:])
        }
        
        context?.prepareLivePhotoForPlayback(withTargetSize: .zero, options: nil) { (livePhoto, error) in
            guard let livePhoto = livePhoto else { return }
            self.editedLivePhoto = livePhoto
            self.node.livePhotoNode.photoNode?.livePhoto = livePhoto
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "livePhotoFilterActivityOff"), object: nil)

        }
        print("end")
    }
    
    
    
}

extension FilterPickerController: ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height = collectionNode.bounds.height - 10
        return ASSizeRangeMake(CGSize(width: UIScreen.screenWidth() / 3.5, height: height), CGSize(width: UIScreen.screenWidth() / 3.5, height: height))
    }
    
    //start
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let filter = FilterType.allValues[indexPath.row]
        selectedFilter = indexPath.row
        self.filter = filter.rawValue
        if indexPath.row == 0 {
            self.node.livePhotoNode.photoNode?.livePhoto = self.livePhoto
            let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            rightBarButtonItem.tintColor = UIColor.textColor()
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "livePhotoFilterActivity"), object: nil)
            processLivePhoto(input: self.editingInput!, inputFilter: filter.rawValue)
            self.node.livePhotoNode.photoNode?.livePhoto = self.livePhoto
            let rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(savePressed))
            rightBarButtonItem.tintColor = UIColor.textColor()
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return FilterType.allValues.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let filter = FilterType.allValues[indexPath.row]
        let node = FilterCellNode(filterType: filter, image: selectedImage)
        return node
    }
}

extension FilterPickerController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Filter", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
        rightBarButtonItem.tintColor = UIColor.textColor()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    @objc func savePressed(){
        saveEdit(filter: filter ) {
            DispatchQueue.main.async {
                let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.nextPressed))
                rightBarButtonItem.tintColor = UIColor.textColor()
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    @objc func nextPressed() {
        if selectedFilter == 0 {
            DispatchQueue.main.async {
                //Call resize image
                let controller = EditPhotoViewController(livePhoto: self.livePhoto, displayPhoto: self.livePhoto, tmpVideo: self.originalVideoURL!, tmpPhoto: self.originalPhotoURL!)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let controller = EditPhotoViewController(livePhoto: self.livePhoto, displayPhoto: self.editedLivePhoto!, tmpVideo: tmpVideoURL, tmpPhoto: tmpPhotoURL)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

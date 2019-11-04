//
//  FilterPickerController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import PhotosUI
import AsyncDisplayKit
import CoreImage

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getEditingInput(asset: PHAsset) {
        print("Get input called")
        asset.requestContentEditingInput(with: .none) { (input, status) in
            print("Successfully requested asset")
            self.editingInput = input
        }
    }
    
    var context: PHLivePhotoEditingContext?
    var videoContext: CIContext?
    
    func processVideo(){
        LivePhoto.extractResources(from: self.livePhoto) { (livePhoto) in
            let filter = CIFilter(name: "CIGaussianBlur")!
            let asset = AVAsset(url: livePhoto?.pairedVideo ?? URL(string: "")!)
            let composition = AVVideoComposition(asset: asset) { (request) in
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                filter.setValue(source, forKey: kCIInputImageKey)

                // Vary filter parameters based on video timing
                let seconds = CMTimeGetSeconds(request.compositionTime)
                filter.setValue(seconds * 10.0, forKey: kCIInputRadiusKey)

                // Crop the blurred output to the bounds of the original image
                let output = filter.outputImage!.cropped(to: request.sourceImage.extent)

                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            }
            
            let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080)
            export?.outputFileType = AVFileType.mov
            let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(ProcessInfo().globallyUniqueString)
            .appendingPathExtension("mp4")
            export?.outputURL = tmpURL
            export?.videoComposition = composition
            export?.exportAsynchronously(completionHandler: {
                
            })
            
        }
    }
    
    func processPhoto(url: URL){
        let context = CIContext()                                           // 1
         
        let filter = CIFilter(name: "CIGaussianBlur")!                      // 2
        filter.setValue(1.0, forKey: kCIInputIntensityKey)
        let image = CIImage(contentsOf: url)                                // 3
        filter.setValue(image, forKey: kCIInputImageKey)
        let result = filter.outputImage!                                    // 4
        let cgImage = context.createCGImage(result, from: result.extent)    // 5
        let content = UIImage(cgImage: cgImage!)
        
    }
    
    func processLivePhoto(input: PHContentEditingInput, inputFilter: String) {
        self.filter = inputFilter
        context = PHLivePhotoEditingContext(livePhotoEditingInput: self.editingInput!)
        context?.frameProcessor = { frame, _ in
            return frame.image.applyingFilter(inputFilter, parameters: [:])
        }
        
        context?.prepareLivePhotoForPlayback(withTargetSize: .zero, options: nil) { (livePhoto, error) in
            guard let livePhoto = livePhoto else { return }
            self.editedLivePhoto = livePhoto
            self.node.livePhotoNode.photoNode?.livePhoto = livePhoto
        }
    }
    
    func saveEdit(completion: @escaping () -> Void) {
        let output = PHContentEditingOutput(contentEditingInput: self.editingInput!)
        let adjustmentData = PHAdjustmentData(formatIdentifier: identifier, formatVersion: formatVersion, data: filter.data(using: .utf8)!)
        output.adjustmentData = adjustmentData
        context?.saveLivePhoto(to: output, options: nil, completionHandler: { (success, error) in
            if success {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest(for: self.asset).contentEditingOutput = output
                }, completionHandler: { (success, error) in
                    if success {
                        print("success saving processed live photo")
                        completion()
                    } else {
                        print("error saving processed live photo")
                        print(error.debugDescription)
                        print(error!.localizedDescription)
                        completion()
                    }
                })
                print("Finished adding filter")
            } else {
                print("can't process live photo: \(error ?? "Err" as! Error)")
                completion()
            }
        })
    }
    
}

extension FilterPickerController: ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height = collectionNode.bounds.height - 10
        return ASSizeRangeMake(CGSize(width: UIScreen.screenWidth() / 3.5, height: height), CGSize(width: UIScreen.screenWidth() / 3.5, height: height))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let filter = FilterType.allValues[indexPath.row]
        selectedFilter = indexPath.row
        if indexPath.row == 0 {
            self.node.livePhotoNode.photoNode?.livePhoto = self.livePhoto
            let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            rightBarButtonItem.tintColor = UIColor.textColor()
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            processLivePhoto(input: editingInput!, inputFilter: filter.rawValue)
            let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
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
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    @objc func savePressed(){
        saveEdit {
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
                let controller = EditPhotoViewController(livePhoto: self.livePhoto, displayPhoto: self.livePhoto)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let controller = EditPhotoViewController(livePhoto: self.livePhoto, displayPhoto: self.editedLivePhoto!)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

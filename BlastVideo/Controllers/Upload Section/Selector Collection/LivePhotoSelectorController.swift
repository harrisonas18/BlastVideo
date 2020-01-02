//
//  LivePhotoSelectorController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import Photos

class LivePhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var livePhoto: PHLivePhoto?
    var selectedAsset: PHAsset?
    var selectedImage: UIImage?
    var livePhotos = [UIImage]()
    var assets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        collectionView?.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        setUpNavBar()
        checkForPhotoLibraryAccess {
            self.fetchPhotos()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex), name: Notification.Name("ChangeIndex"), object: nil)
        
    }
    
    @objc func changeIndex(){
        self.tabBarController?.selectedIndex = 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        let cell = collectionView.cellForItem(at: indexPath) as! PhotoSelectorCell

        if cell.isSelected {
            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            self.selectedAsset = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
            return false
        }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoSelectorCell
        cell.isSelected = true
        self.selectedAsset = assets[indexPath.item]
        self.selectedImage = livePhotos[indexPath.item]
        navigationItem.rightBarButtonItem?.isEnabled = true
        getLivePhoto()
    }
    
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let liveImagesPredicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
        fetchOptions.predicate = liveImagesPredicate
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: assetsFetchOptions())
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (livePhoto, info) in
                    
                    if let livePhoto = livePhoto {
                        self.livePhotos.append(livePhoto)
                        self.assets.append(asset)
                    }
                    let index = self.livePhotos.count - 1
                    DispatchQueue.main.async {
                        self.collectionView?.insertItems(at: [IndexPath(row: index, section: 0)])
                    }
//                    if count % 10 == 0 {
//                        DispatchQueue.main.async {
//                            self.collectionView?.reloadData()
//                        }
//                    } else if count == allPhotos.count - 1 {
//                        DispatchQueue.main.async {
//                            self.collectionView?.reloadData()
//                        }
//                    }
                    
                })
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return livePhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = livePhotos[indexPath.item]
        
        return cell
    }
    
    func getLivePhoto() {
        guard (selectedAsset != nil) else {
            return
        }
        let manager = PHImageManager.default()
        let targetSize = CGSize(width: 1080, height: 1920)
        let options = PHLivePhotoRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        manager.requestLivePhoto(for: selectedAsset!, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (livePhoto, info) in
            
            self.livePhoto = livePhoto
            
        })
    }
    
    @objc func segueToEdit(){
        let editController = FilterPickerController(livePhoto: self.livePhoto!, asset: self.selectedAsset!, selectedImage: self.selectedImage!)
        PostManager.shared.livePhoto = self.livePhoto!
        self.navigationController?.pushViewController(editController, animated: true)
    }
}
extension LivePhotoSelectorController {
    func setUpNavBar() {
        
        let navLabel = UILabel()
        let boldFont = UIFont.init(name: "Modulus-Bold", size: 20.0)
        let navTitle = NSMutableAttributedString(string: "Choose Live Photo", attributes:[
            NSAttributedString.Key.font: boldFont!,
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        button.addTarget(self, action: #selector(segueToEdit), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(UIColor.textColor(), for: .normal)
        let rightBarItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.isTranslucent = false

        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        
    }
}



//
//  Extensions.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import PhotosUI
import AsyncDisplayKit


extension PHLivePhotoView {
    
    func fetchLivePhoto(post: Post, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let livePhoto = StorageCacheController.shared.livePhotoCache.object(forKey: post.id! as NSString) {
                DispatchQueue.main.async {
                    self.livePhoto = livePhoto
                }
                completion()
            } else {
                StorageCacheController.shared.retrieveLivePhoto(post: post) { (livePhoto) in
                    DispatchQueue.main.async {
                        UIView.transition(with: self,
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: { self.livePhoto = livePhoto},
                        completion: nil)
                    }
                    completion()
                }
            }
        }
    }
    
    
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
 func startShimmeringEffect() {
    let light = UIColor.gray.cgColor
    let alpha = UIColor(red: 206/255, green: 10/255, blue: 10/255, alpha: 0.7).cgColor
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
    gradient.colors = [light, alpha, light]
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1.0,y: 0.525)
    gradient.locations = [0.35, 0.50, 0.65]
    self.layer.mask = gradient
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9,1.0]
    animation.duration = 1.5
    animation.repeatCount = HUGE
    gradient.add(animation, forKey: "shimmer")
    }
    func stopShimmeringEffect() {
        self.layer.mask = nil
    }
}

extension UIColor {
    
    class func primaryBackgroundColor() -> UIColor {
        return UIColor.init(red: 237/255, green: 239/255, blue: 242/255, alpha: 1.0)
    }
    
    class func primaryBarTintColor() -> UIColor {
        return UIColor.init(red: 57/255, green: 59/255, blue: 63/255, alpha: 1.0)
    }
    
    class func containerBackgroundColor() -> UIColor {
        return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    class func containerBorderColor() -> UIColor {
        return UIColor.init(red: 231/255, green: 232/255, blue: 235/255, alpha: 1.0)
    }
    
    class func textColor() -> UIColor {
        return UIColor.init(red: 27.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
}

extension UIScreen {
    class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
}
extension UIImage {
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
}


extension UIScrollView {
    
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    func isScrolledToTop() -> Bool{
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        
        if topOffset == CGPoint(x: 0, y: -contentInset.top) {
            return true
        } else {
            return false
        }
    }
    
}

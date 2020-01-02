//
//  VideoCompressionWrapper.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import NextLevelSessionExporter
import VideoToolbox

class VideoCompressionWrapper: NSObject {
    
    var videoURL: URL?
    
    func exportVideo(videoURL: URL, videoHeight: Int?, videoWidth: Int?, completion: @escaping (_ newVideoURL: URL?)->Void) {
        let asset = AVURLAsset(url: self.videoURL!, options: nil)
        //let data = NSData(contentsOf: self.videoURL!)!
        let exporter = NextLevelSessionExporter(withAsset: asset)
        let compressionDict: [String: Any] = [
            AVVideoAverageBitRateKey: NSNumber(integerLiteral: 4250000),
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel as String,
        ]
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        
        exporter.outputFileType = AVFileType.mov
        exporter.outputURL = tmpURL
        
        exporter.videoOutputConfiguration = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(integerLiteral: 750),
            AVVideoHeightKey: NSNumber(integerLiteral: 1334),
            AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
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
                    let data = NSData(contentsOf: tmpURL)
                    print((Double(data!.length) / 1048576.0), " mb")
                    print("NextLevelSessionExporter, export completed, \(exporter.outputURL?.description ?? "")")
                    completion(tmpURL)
                    break
                default:
                    print("NextLevelSessionExporter, did not complete")
                    completion(nil)
                    break
                }
                break
            case .failure(let error):
                print("NextLevelSessionExporter, failed to export \(error)")
                completion(nil)
                break
            }
        })
        
    }
    

}//End of Class



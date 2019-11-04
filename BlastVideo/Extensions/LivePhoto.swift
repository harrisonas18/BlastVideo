//
//  LivePhoto.swift
//  Live Photos
//
//  Created by Alexander Pagliaro on 7/25/18.
//  Copyright © 2018 Limit Point LLC. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class LivePhoto {
    // MARK: PUBLIC
    typealias LivePhotoResources = (pairedImage: URL, pairedVideo: URL)
    /// Returns the paired image and video for the given PHLivePhoto
    
    public class func extractResources(from livePhoto: PHLivePhoto, completion: @escaping (LivePhotoResources?) -> Void) {
        queue.async {
            shared.extractResources(from: livePhoto, completion: completion)
        }
    }
    
    /// Generates a PHLivePhoto from an image and video.  Also returns the paired image and video.
    public class func generate(from imageURL: URL?, videoURL: URL, progress: @escaping (CGFloat) -> Void, completion: @escaping (PHLivePhoto?, LivePhotoResources?) -> Void) {
        queue.async {
            shared.generate(from: imageURL, videoURL: videoURL, progress: progress, completion: completion)
        }
    }
    
    /// Save a Live Photo to the Photo Library by passing the paired image and video.
    public class func saveToLibrary(_ resources: LivePhotoResources, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: resources.pairedVideo, options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: resources.pairedImage, options: options)
        }, completionHandler: { (success, error) in
            if error != nil {
                print(error as Any)
            }
            completion(success)
        })
    }
    
    // MARK: PRIVATE
    private static let shared = LivePhoto()
    private static let queue = DispatchQueue(label: "com.limit-point.LivePhotoQueue", attributes: .concurrent)
    
    //Cache Directory
    lazy private var cacheDirectory: URL? = {
        if let cacheDirectoryURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let fullDirectory = cacheDirectoryURL.appendingPathComponent("com.limit-point.LivePhoto", isDirectory: true)
            if !FileManager.default.fileExists(atPath: fullDirectory.absoluteString) {
                try? FileManager.default.createDirectory(at: fullDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            return fullDirectory
        }
        return nil
    }()
    //Clear Cache with a de initialization
    deinit {
        clearCache()
    }
    
    //Generate Key Photo frame from the passed video URL
    private func generateKeyPhoto(from videoURL: URL) -> URL? {
        var percent:Float = 0.5
        let videoAsset = AVURLAsset(url: videoURL)
        if let stillImageTime = videoAsset.stillImageTime() {
            percent = Float(stillImageTime.value) / Float(videoAsset.duration.value)
        }
        guard let imageFrame = videoAsset.getAssetFrame(percent: percent) else { return nil }
        guard let jpegData = imageFrame.jpegData(compressionQuality: 1.0) else { return nil }
        guard let url = cacheDirectory?.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg") else { return nil }
        do {
            try? jpegData.write(to: url)
            return url
        }
    }
    
    //Clear the file cache
    private func clearCache() {
        if let cacheDirectory = cacheDirectory {
            try? FileManager.default.removeItem(at: cacheDirectory)
        }
    }
    
    //Generate a Live Photo from the passed Video and Photo URL's while showing progress
    private func generate(from imageURL: URL?, videoURL: URL, progress: @escaping (CGFloat) -> Void, completion: @escaping (PHLivePhoto?, LivePhotoResources?) -> Void) {
        guard let cacheDirectory = cacheDirectory else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        
        let assetIdentifier = UUID().uuidString
        let _keyPhotoURL = imageURL ?? generateKeyPhoto(from: videoURL)
        guard let keyPhotoURL = _keyPhotoURL, let pairedImageURL = addAssetID(assetIdentifier, toImage: keyPhotoURL, saveTo: cacheDirectory.appendingPathComponent(assetIdentifier).appendingPathExtension("jpg")) else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        
        addAssetID(assetIdentifier, toVideo: videoURL, saveTo: cacheDirectory.appendingPathComponent(assetIdentifier).appendingPathExtension("mov"), progress: progress) { (_videoURL) in
            if let pairedVideoURL = _videoURL {
                _ = PHLivePhoto.request(withResourceFileURLs: [pairedVideoURL, pairedImageURL], placeholderImage: nil, targetSize: CGSize.zero, contentMode: PHImageContentMode.aspectFit, resultHandler: { (livePhoto: PHLivePhoto?, info: [AnyHashable : Any]) -> Void in
                    if let isDegraded = info[PHLivePhotoInfoIsDegradedKey] as? Bool, isDegraded {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(livePhoto, (pairedImageURL, pairedVideoURL))
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
    
    //Extracts Video and Photo URLS from passed Live Photo Object
    private func extractResources(from livePhoto: PHLivePhoto, to directoryURL: URL, completion: @escaping (LivePhotoResources?) -> Void) {
        let assetResources = PHAssetResource.assetResources(for: livePhoto)
        let group = DispatchGroup()
        var keyPhotoURL: URL?
        var videoURL: URL?
        for resource in assetResources {
            let buffer = NSMutableData()
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            group.enter()
            PHAssetResourceManager.default().requestData(for: resource, options: options, dataReceivedHandler: { (data) in
                buffer.append(data)
            }) { (error) in
                if error == nil {
                    if resource.type == .pairedVideo {
                        videoURL = self.saveAssetResource(resource, to: directoryURL, resourceData: buffer as Data)
                    } else {
                        keyPhotoURL = self.saveAssetResource(resource, to: directoryURL, resourceData: buffer as Data)
                    }
                } else {
                    print(error as Any)
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            guard let pairedPhotoURL = keyPhotoURL, let pairedVideoURL = videoURL else {
                completion(nil)
                return
            }
            completion((pairedPhotoURL, pairedVideoURL))
        }
    }
    
    //Not sure what this is for
    private func extractResources(from livePhoto: PHLivePhoto, completion: @escaping (LivePhotoResources?) -> Void) {
        if let cacheDirectory = cacheDirectory {
            extractResources(from: livePhoto, to: cacheDirectory, completion: completion)
        }
    }
    
    //Noy sure what this is for
    private func saveAssetResource(_ resource: PHAssetResource, to directory: URL, resourceData: Data) -> URL? {
        let fileExtension = UTTypeCopyPreferredTagWithClass(resource.uniformTypeIdentifier as CFString,kUTTagClassFilenameExtension)?.takeRetainedValue()
        
        guard let ext = fileExtension else {
            return nil
        }
        
        var fileUrl = directory.appendingPathComponent(NSUUID().uuidString)
        fileUrl = fileUrl.appendingPathExtension(ext as String)
        
        do {
            try resourceData.write(to: fileUrl, options: [Data.WritingOptions.atomic])
        } catch {
            print("Could not save resource \(resource) to filepath \(String(describing: fileUrl))")
            return nil
        }
        
        return fileUrl
    }
    
    
    //Not sure what this is but looks like it creates an ID to save resources to the Image URL
    func addAssetID(_ assetIdentifier: String, toImage imageURL: URL, saveTo destinationURL: URL) -> URL? {
        guard let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil),
            let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
            var imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable : Any] else { return nil }
        let assetIdentifierKey = "17"
        let assetIdentifierInfo = [assetIdentifierKey : assetIdentifier]
        imageProperties[kCGImagePropertyMakerAppleDictionary] = assetIdentifierInfo
        CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, imageProperties as CFDictionary)
        CGImageDestinationFinalize(imageDestination)
        return destinationURL
    }
    
    //Variable instances of the mentioned Classes
    var audioReader: AVAssetReader?
    var videoReader: AVAssetReader?
    var assetWriter: AVAssetWriter?
    
    //Not sure what this is but looks like it creates an ID to save resources to the Video URL
    func addAssetID(_ assetIdentifier: String, toVideo videoURL: URL, saveTo destinationURL: URL, progress: @escaping (CGFloat) -> Void, completion: @escaping (URL?) -> Void) {
        
        var audioWriterInput: AVAssetWriterInput?
        var audioReaderOutput: AVAssetReaderOutput?
        let videoAsset = AVURLAsset(url: videoURL)
        let frameCount = videoAsset.countFrames(exact: false)
        guard let videoTrack = videoAsset.tracks(withMediaType: .video).first else {
            completion(nil)
            return
        }
        do {
            // Create the Asset Writer
            assetWriter = try AVAssetWriter(outputURL: destinationURL, fileType: .mov)
            // Create Video Reader Output
            videoReader = try AVAssetReader(asset: videoAsset)
            let videoReaderSettings = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)]
            let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)
            videoReader?.add(videoReaderOutput)
            // Create Video Writer Input
            let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: [AVVideoCodecKey : AVVideoCodecType.h264, AVVideoWidthKey : videoTrack.naturalSize.width, AVVideoHeightKey : videoTrack.naturalSize.height])
            videoWriterInput.transform = videoTrack.preferredTransform
            videoWriterInput.expectsMediaDataInRealTime = true
            assetWriter?.add(videoWriterInput)
            // Create Audio Reader Output & Writer Input
            if let audioTrack = videoAsset.tracks(withMediaType: .audio).first {
                do {
                    let _audioReader = try AVAssetReader(asset: videoAsset)
                    let _audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
                    _audioReader.add(_audioReaderOutput)
                    audioReader = _audioReader
                    audioReaderOutput = _audioReaderOutput
                    let _audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
                    _audioWriterInput.expectsMediaDataInRealTime = false
                    assetWriter?.add(_audioWriterInput)
                    audioWriterInput = _audioWriterInput
                } catch {
                    print(error)
                }
            }
            // Create necessary identifier metadata and still image time metadata
            let assetIdentifierMetadata = metadataForAssetID(assetIdentifier)
            let stillImageTimeMetadataAdapter = createMetadataAdaptorForStillImageTime()
            assetWriter?.metadata = [assetIdentifierMetadata]
            assetWriter?.add(stillImageTimeMetadataAdapter.assetWriterInput)
            // Start the Asset Writer
            assetWriter?.startWriting()
            assetWriter?.startSession(atSourceTime: CMTime.zero)
            // Add still image metadata
            let _stillImagePercent: Float = 0.5
            stillImageTimeMetadataAdapter.append(AVTimedMetadataGroup(items: [metadataItemForStillImageTime()],timeRange: videoAsset.makeStillImageTimeRange(percent: _stillImagePercent, inFrameCount: frameCount)))
            // For end of writing / progress
            var writingVideoFinished = false
            var writingAudioFinished = false
            var currentFrameCount = 0
            func didCompleteWriting() {
                guard writingAudioFinished && writingVideoFinished else { return }
                assetWriter?.finishWriting {
                    if self.assetWriter?.status == .completed {
                        completion(destinationURL)
                    } else {
                        completion(nil)
                    }
                }
            }
            // Start writing video
            if videoReader?.startReading() ?? false {
                videoWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "videoWriterInputQueue")) {
                    while videoWriterInput.isReadyForMoreMediaData {
                        if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer()  {
                            currentFrameCount += 1
                            let percent:CGFloat = CGFloat(currentFrameCount)/CGFloat(frameCount)
                            progress(percent)
                            if !videoWriterInput.append(sampleBuffer) {
                                self.videoReader?.cancelReading()
                            }
                        } else {
                            videoWriterInput.markAsFinished()
                            writingVideoFinished = true
                            didCompleteWriting()
                        }
                    }
                }
            } else {
                writingVideoFinished = true
                didCompleteWriting()
            }
            // Start writing audio
            if audioReader?.startReading() ?? false {
                audioWriterInput?.requestMediaDataWhenReady(on: DispatchQueue(label: "audioWriterInputQueue")) {
                    while audioWriterInput?.isReadyForMoreMediaData ?? false {
                        guard let sampleBuffer = audioReaderOutput?.copyNextSampleBuffer() else {
                            audioWriterInput?.markAsFinished()
                            writingAudioFinished = true
                            didCompleteWriting()
                            return
                        }
                        audioWriterInput?.append(sampleBuffer)
                    }
                }
            } else {
                writingAudioFinished = false
                didCompleteWriting()
            }
        } catch {
            print(error)
            completion(nil)
        }
    }
    
    //Creates the metadata for the passed Asset ID for the Video
    private func metadataForAssetID(_ assetIdentifier: String) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        let keyContentIdentifier =  "com.apple.quicktime.content.identifier"
        let keySpaceQuickTimeMetadata = "mdta"
        item.key = keyContentIdentifier as (NSCopying & NSObjectProtocol)?
        item.keySpace = AVMetadataKeySpace(rawValue: keySpaceQuickTimeMetadata)
        item.value = assetIdentifier as (NSCopying & NSObjectProtocol)?
        item.dataType = "com.apple.metadata.datatype.UTF-8"
        return item
    }
    //Creates metadata for the still image at the time where in the video from where it was taken
    private func createMetadataAdaptorForStillImageTime() -> AVAssetWriterInputMetadataAdaptor {
        let keyStillImageTime = "com.apple.quicktime.still-image-time"
        let keySpaceQuickTimeMetadata = "mdta"
        let spec : NSDictionary = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as NSString:
            "\(keySpaceQuickTimeMetadata)/\(keyStillImageTime)",
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as NSString:
            "com.apple.metadata.datatype.int8"            ]
        var desc : CMFormatDescription? = nil
        CMMetadataFormatDescriptionCreateWithMetadataSpecifications(allocator: kCFAllocatorDefault, metadataType: kCMMetadataFormatType_Boxed, metadataSpecifications: [spec] as CFArray, formatDescriptionOut: &desc)
        let input = AVAssetWriterInput(mediaType: .metadata,
                                       outputSettings: nil, sourceFormatHint: desc)
        return AVAssetWriterInputMetadataAdaptor(assetWriterInput: input)
    }
    
    //Similar to above method
    private func metadataItemForStillImageTime() -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        let keyStillImageTime = "com.apple.quicktime.still-image-time"
        let keySpaceQuickTimeMetadata = "mdta"
        item.key = keyStillImageTime as (NSCopying & NSObjectProtocol)?
        item.keySpace = AVMetadataKeySpace(rawValue: keySpaceQuickTimeMetadata)
        item.value = 0 as (NSCopying & NSObjectProtocol)?
        item.dataType = "com.apple.metadata.datatype.int8"
        return item
    }
    
}

//Extension for AVAsset
fileprivate extension AVAsset {
    
    //Method counts frames
    func countFrames(exact:Bool) -> Int {
        
        var frameCount = 0
        
        if let videoReader = try? AVAssetReader(asset: self)  {
            
            if let videoTrack = self.tracks(withMediaType: .video).first {
                
                frameCount = Int(CMTimeGetSeconds(self.duration) * Float64(videoTrack.nominalFrameRate))
                
                
                if exact {
                    
                    frameCount = 0
                    
                    let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
                    videoReader.add(videoReaderOutput)
                    
                    videoReader.startReading()
                    
                    // count frames
                    while true {
                        let sampleBuffer = videoReaderOutput.copyNextSampleBuffer()
                        if sampleBuffer == nil {
                            break
                        }
                        frameCount += 1
                    }
                    
                    videoReader.cancelReading()
                }
                
                
            }
        }
        
        return frameCount
    }
    
    //Returns the time to where the still image was taken
    func stillImageTime() -> CMTime?  {
        
        var stillTime:CMTime? = nil
        
        if let videoReader = try? AVAssetReader(asset: self)  {
            
            if let metadataTrack = self.tracks(withMediaType: .metadata).first {
                
                let videoReaderOutput = AVAssetReaderTrackOutput(track: metadataTrack, outputSettings: nil)
                
                videoReader.add(videoReaderOutput)
                
                videoReader.startReading()
                
                let keyStillImageTime = "com.apple.quicktime.still-image-time"
                let keySpaceQuickTimeMetadata = "mdta"
                
                var found = false
                
                while found == false {
                    if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer() {
                        if CMSampleBufferGetNumSamples(sampleBuffer) != 0 {
                            let group = AVTimedMetadataGroup(sampleBuffer: sampleBuffer)
                            for item in group?.items ?? [] {
                                if item.key as? String == keyStillImageTime && item.keySpace!.rawValue == keySpaceQuickTimeMetadata {
                                    stillTime = group?.timeRange.start
                                    //print("stillImageTime = \(CMTimeGetSeconds(stillTime!))")
                                    found = true
                                    break
                                }
                            }
                        }
                    }
                    else {
                        break;
                    }
                }
                
                videoReader.cancelReading()
                
            }
        }
        
        return stillTime
    }
    
    //Time range for the still image
    func makeStillImageTimeRange(percent:Float, inFrameCount:Int = 0) -> CMTimeRange {
        
        var time = self.duration
        
        var frameCount = inFrameCount
        
        if frameCount == 0 {
            frameCount = self.countFrames(exact: true)
        }
        
        let frameDuration = Int64(Float(time.value) / Float(frameCount))
        
        time.value = Int64(Float(time.value) * percent)
        
        //print("stillImageTime = \(CMTimeGetSeconds(time))")
        
        return CMTimeRangeMake(start: time, duration: CMTimeMake(value: frameDuration, timescale: time.timescale))
    }
    
    //Gets frame based on the percentage point that is passed
    func getAssetFrame(percent:Float) -> UIImage?
    {
        
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        
        imageGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1,timescale: 100)
        imageGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1,timescale: 100)
        
        var time = self.duration
        
        time.value = Int64(Float(time.value) * percent)
        
        do {
            var actualTime = CMTime.zero
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime:&actualTime)
            
            let img = UIImage(cgImage: imageRef)
            
            return img
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}
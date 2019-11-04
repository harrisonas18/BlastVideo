
//
//  HomeTableViewCell.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import UIKit
import AVFoundation
import KILabel


class DiscoverDetailCollectionViewCell: UICollectionViewCell {
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = postImageView.frame
            playerLayer?.backgroundColor = UIColor.white.cgColor
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            playerLayer?.frame.size.height = UIScreen.main.bounds.width / post!.ratio!
            self.contentView.layer.addSublayer(playerLayer!)
            player?.playImmediately(atRate: 1.0)
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
    }
    
}

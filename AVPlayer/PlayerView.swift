//
//  PlayerView.swift
//  AVPlayer
//
//  Created by Francis Tseng on 2017/9/6.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        // swiftlint:disable force_cast
        return layer as! AVPlayerLayer
        // swiftlint:enable force_cast
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

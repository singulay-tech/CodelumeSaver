//
//  VideoView.swift
//  CodelumeSaver
//
//  Created by lyke on 2025/9/19.
//

import AppKit
import AVKit
import AVFoundation
import CodelumeBundle

class VideoView: NSView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layout() {
        super.layout()
        playerLayer?.frame = self.bounds
    }
    
    private func setupView() {
        let defaultVideoURL = Bundle(for: type(of: self)).url(forResource: "codelume", withExtension: "mp4")!
        if let filePath = ScreenSaverConfig().getFilePath(),
           FileManager.default.fileExists(atPath: filePath) {
            let fileURL = URL(fileURLWithPath: filePath)
            if fileURL.pathExtension != "bundle" {
                print("screensaver type is video.")
                player = AVPlayer(url: fileURL)
            } else {
                print("screensaver type is bundle")
                let bundle = VideoBundle()
                _ = bundle.open(wallpaperUrl: fileURL)
                player = AVPlayer(url: bundle.videoUrl ?? defaultVideoURL)
            }
            
        } else {
            print("file not exists, use default video.")
            player = AVPlayer(url: defaultVideoURL)
        }

        if let player = player {
            playerLayer = AVPlayerLayer(player: player)
            if let playerLayer = playerLayer {
                playerLayer.frame = self.bounds
                playerLayer.videoGravity = .resizeAspectFill
                self.layer = playerLayer
                self.wantsLayer = true

                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerItemDidReachEnd),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem
                )
                player.isMuted = true
                player.play()
            }
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
            player?.play()
        }
    }
    
    func stop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
}

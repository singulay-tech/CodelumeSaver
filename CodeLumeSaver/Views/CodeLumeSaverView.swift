//
//  CodeLumeSaverView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/17.
//

import AppKit
import ScreenSaver
import AVKit
import AVFoundation

class CodeLumeSaverView: ScreenSaverView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return nil
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(screenSaverWillStop),
            name: NSNotification.Name("com.apple.screensaver.didstop"),
            object: nil
        )

        if let videoURL = Bundle(for: type(of: self)).url(forResource: "codelume_1", withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
            
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
                    player.play()
                }
            }
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
            player?.play()
        }
    }
    
    @objc private func screenSaverWillStop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
}

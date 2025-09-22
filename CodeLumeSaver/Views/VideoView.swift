//
//  VideoView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/19.
//

import AppKit
import AVKit
import AVFoundation

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
        if let savedPath = UserDefaults.standard.string(forKey: "CodeLumeSelectedFilePath"),
           FileManager.default.fileExists(atPath: savedPath) {
            let videoURL = URL(fileURLWithPath: savedPath)
            player = AVPlayer(url: videoURL)
        } else {
            if let videoURL = Bundle(for: type(of: self)).url(forResource: "codelume_1", withExtension: "mp4") {
                player = AVPlayer(url: videoURL)
            }
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

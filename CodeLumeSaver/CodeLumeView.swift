//
//  CodeLumeView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/17.
//

import AppKit
import ScreenSaver
import AVKit
import AVFoundation

class CodeLumeView: NSView {
    private var videoFound: Bool = false
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        if let videoURL = Bundle(for: type(of: self)).url(forResource: "codelume_1", withExtension: "mp4") {
            videoFound = true
            NSLog("找到视频文件: \(videoURL.path)")
            
            // 初始化播放器
            player = AVPlayer(url: videoURL)
            
            // 设置播放器层
            if let player = player {
                playerLayer = AVPlayerLayer(player: player)
                if let playerLayer = playerLayer {
                    playerLayer.frame = self.bounds
                    playerLayer.videoGravity = .resizeAspectFill // 保持视频比例并填充整个视图
                    self.layer = playerLayer
                    self.wantsLayer = true // 启用视图的层
                    
                    // 设置循环播放
                    player.actionAtItemEnd = .none
                    NotificationCenter.default.addObserver(self, 
                                                         selector: #selector(playerItemDidReachEnd), 
                                                         name: .AVPlayerItemDidPlayToEndTime, 
                                                         object: player.currentItem)
                    
                    // 开始播放
                    player.play()
                }
            }
        } else {
            // 如果找不到视频文件，显示错误日志
            NSLog("无法找到视频文件: codelume_1.mp4")
            videoFound = false
        }
    }
    
    // 处理视频播放结束事件，实现循环播放
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero)
            player?.play()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 只有在视频未找到时才绘制圆形
        if !videoFound {
            // 设置白色填充色
            NSColor.white.setFill()
            
            // 创建一个圆形路径，圆心在视图中心，半径为100
            let circlePath = NSBezierPath(ovalIn: NSRect(
                x: self.bounds.midX - 100,
                y: self.bounds.midY - 100,
                width: 200,
                height: 200
            ))
            
            // 填充圆形
            circlePath.fill()
        }
    }
    
    // 确保当视图大小改变时，播放器层也会相应调整
    override func layout() {
        super.layout()
        playerLayer?.frame = self.bounds
    }
}


//
//  CodelumeView.swift
//  CodelumeSaver
//
//  Created by lyke on 2025/9/19.
//

import AppKit

class CodelumeView: NSView {
    private var currentView: NSView?
    
    required override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layout() {
        super.layout()
        currentView?.frame = self.bounds
    }
    
    private func setupView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(preferencesDidChange),
            name: .PreferencesDidChange,
            object: nil
        )
        
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(screenSaverWillStop),
            name: NSNotification.Name("com.apple.screensaver.didstop"),
            object: nil
        )
        
        loadViewForCurrentType()
    }
    
    private func loadViewForCurrentType() {
        if let currentView = currentView {
            if let stoppableView = currentView as? VideoView {
                stoppableView.stop()
            } else if let stoppableView = currentView as? SpriteView {
                stoppableView.stop()
            } else if let stoppableView = currentView as? SceneView {
                stoppableView.stop()
            }
            currentView.removeFromSuperview()
            self.currentView = nil
        }
        
        switch ScreenSaverConfig().getScreensaverType() {
        case .Video:
            let videoView = VideoView(frame: self.bounds)
            self.addSubview(videoView)
            self.currentView = videoView
        case .Bundle:
            loadBundle()
        }
    }
    
    private func loadBundle() {
        switch ScreenSaverConfig().getBundleType() {
        case .Video:
            let videoView = VideoView(frame: self.bounds)
            self.addSubview(videoView)
            self.currentView = videoView
        case .Sprite:
            let spriteView = SpriteView(frame: self.bounds)
            self.addSubview(spriteView)
            self.currentView = spriteView
        case .Scene:
            let sceneView = SceneView(frame: self.bounds)
            self.addSubview(sceneView)
            self.currentView = sceneView
        }
    }
    
    @objc private func preferencesDidChange() {
        loadViewForCurrentType()
    }
    
    @objc private func screenSaverWillStop() {
        if let currentView = currentView {
            if let stoppableView = currentView as? VideoView {
                stoppableView.stop()
            } else if let stoppableView = currentView as? SpriteView {
                stoppableView.stop()
            } else if let stoppableView = currentView as? SceneView {
                stoppableView.stop()
            }
            currentView.removeFromSuperview()
            self.currentView = nil
        }
        
        NotificationCenter.default.removeObserver(self)
        DistributedNotificationCenter.default.removeObserver(self)
    }
}

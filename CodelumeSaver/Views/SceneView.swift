//
//  SceneView.swift
//  CodelumeSaver
//
//  Created by lyke on 2025/9/22.
//

import AppKit

class SceneView: NSView {
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.darkGray.cgColor
        
        // 暂时为空实现，后续可以添加场景相关功能
    }
    
    func stop() {
        // 清理资源
    }
}

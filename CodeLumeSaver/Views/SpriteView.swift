//
//  SpriteView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/22.
//

import AppKit

class SpriteView: NSView {
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
        self.layer?.backgroundColor = NSColor.black.cgColor
        
        // 暂时为空实现，后续可以添加精灵相关功能
    }
    
    func stop() {
        // 清理资源
    }
}

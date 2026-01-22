//
//  SpriteView.swift
//  CodelumeSaver
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
        self.layer?.backgroundColor = NSColor.green.cgColor
    }
    
    func stop() {
    }
}

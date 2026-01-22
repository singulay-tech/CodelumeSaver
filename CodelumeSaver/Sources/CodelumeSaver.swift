//
//  CodelumeSaverView.swift
//  CodelumeSaver
//
//  Created by lyke on 2025/9/17.
//

import AppKit
import ScreenSaver

class CodelumeSaver: ScreenSaverView {
    private var codeLumeView: CodelumeView? {
        willSet {
            let codeLumeView = self.codeLumeView
            codeLumeView?.removeFromSuperview()
        }

        didSet {
            if let codeLumeView = codeLumeView {
                codeLumeView.autoresizingMask = [.width, .height]
                addSubview(codeLumeView)
            }
        }
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return PreferencesViewController.createPreferencesWindow()
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        codeLumeView = CodelumeView(frame: bounds)
    }
}

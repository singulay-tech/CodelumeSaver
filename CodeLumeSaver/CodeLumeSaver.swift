//
//  CodeLumeSaverView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/17.
//

import AppKit
import ScreenSaver

class CodeLumeSaver: ScreenSaverView {
    private var codeLumeView: CodeLumeView? {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange),
                                               name: .PreferencesDidChange, object: nil)
        preferencesDidChange(nil)
    }
    
    @objc private func preferencesDidChange(_ notification: NSNotification?) {
        codeLumeView = CodeLumeView(frame: bounds)
    }
}

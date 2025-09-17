//
//  CodeLumeSaverView.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/17.
//

import AppKit
import ScreenSaver

class CodeLumeSaverView: ScreenSaverView {
    private var codeLumeView: CodeLumeView?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupCodeLumeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCodeLumeView()
    }
    
    private func setupCodeLumeView() {
        codeLumeView?.removeFromSuperview()

        codeLumeView = CodeLumeView(frame: self.bounds)
        if let codeLumeView = codeLumeView {
            codeLumeView.autoresizingMask = [.width, .height]
            self.addSubview(codeLumeView)
        }
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return nil
    }
}

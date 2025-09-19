//
//  AppDelegate.swift
//  CodeLumeSaverDemo
//
//  Created by lyke on 2025/9/19.
//

import Cocoa
import ScreenSaver

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    
    let view: ScreenSaverView = {
        let view = CodeLumeSaver(frame: .zero, isPreview: false)!
        view.autoresizingMask = [.width, .height]
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let contentView = window.contentView else {
            fatalError("Missing window content view")
        }
        
        view.frame = contentView.bounds
        contentView.addSubview(view)
        
        view.startAnimation()
        Timer.scheduledTimer(timeInterval: view.animationTimeInterval, target: view,
                             selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange),
                                               name: .PreferencesDidChange, object: nil)
        preferencesDidChange(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc private func preferencesDidChange(_ notification: NSNotification?) {
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        guard let sheet = view.configureSheet else { return }

        window.beginSheet(sheet) { [weak sheet] _ in
            sheet?.close()
        }
    }
    
}


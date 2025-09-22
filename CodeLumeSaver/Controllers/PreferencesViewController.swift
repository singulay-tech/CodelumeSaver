//
//  PreferencesViewController.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/19.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func createPreferencesWindow() -> NSWindow? {
        let controller = PreferencesViewController(nibName: "Preferences", bundle: Bundle(for: self))
        let window = NSWindow(contentViewController: controller)
        window.styleMask = [.titled, .closable]
        window.title = "CodeLume Preferences"
        window.setContentSize(NSSize(width: 300, height: 150))
        window.isReleasedWhenClosed = false
        return window
    }
    
    @IBAction func doneButtonClicked(_ sender: NSButton) {
        if let window = view.window {
            if let sheetParent = window.sheetParent {
                sheetParent.endSheet(window)
            } else {
                window.close()
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        if let window = view.window {
            if let sheetParent = window.sheetParent {
                sheetParent.endSheet(window)
            } else {
                window.close()
            }
        }
    }
}

//
//  PreferencesViewController.swift
//  CodelumeSaver
//
//  Created by lyke on 2025/9/19.
//

import Cocoa
import UniformTypeIdentifiers
import ScreenSaver
import CodelumeBundle

class PreferencesViewController: NSViewController {
    @IBOutlet weak var typeComboBox: NSComboBox!
    @IBOutlet weak var selectButton: NSButtonCell!
    @IBOutlet weak var versionLabel: NSTextField!
    
    private var tempSelectedFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVersionLabel()
    }
    
    
    static func createPreferencesWindow() -> NSWindow? {
        let controller = PreferencesViewController(nibName: "Preferences", bundle: Bundle(for: self))
        let window = NSWindow(contentViewController: controller)
        window.styleMask = [.titled, .closable]
        window.title = "Codelume Preferences"
        window.setContentSize(NSSize(width: 300, height: 120))
        window.isReleasedWhenClosed = false
        return window
    }
    
    @IBAction func doneButtonClicked(_ sender: NSButton) {
        if let tempURL = tempSelectedFileURL {
            if tempURL.pathExtension != "bundle" {
                print("import video.")
                ScreenSaverConfig().setScreensaverType(type: .Video)
            } else {
                print("import bundle.")
                ScreenSaverConfig().setScreensaverType(type: .Bundle)
                let bundle = BaseBundle()
                let ret = bundle.open(wallpaperUrl: tempURL)
                if !ret {
                    print("It's not a bundle type supported by CodeLume.")
                    ScreenSaverConfig().resetConfig()
                    cancelButtonClicked(sender)
                    return
                }
                
                let bundleType = bundle.bundleInfo.type
                switch bundleType {
                case .Video:
                    ScreenSaverConfig().setBundleType(type: .Video)
                case .Scene2D:
                    ScreenSaverConfig().setBundleType(type: .Sprite)
                case .Scene3D:
                    ScreenSaverConfig().setBundleType(type: .Scene)
                case .none:
                    print("It's not a bundle type supported by CodeLume.")
                    ScreenSaverConfig().resetConfig()
                    cancelButtonClicked(sender)
                    return
                }
            }
            
            if let destinationURL = copyFileToSandbox(tempURL) {
                print("Copy file to sandbox success, set file path: \(destinationURL.path)")
                ScreenSaverConfig().setFilePath(path: destinationURL.path)
            }
            tempSelectedFileURL = nil
        }
        NotificationCenter.default.post(name: .PreferencesDidChange, object: nil)
        
        cancelButtonClicked(sender)
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
    
    @IBAction func selectButtonClicked(_ sender: NSButtonCell) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowedContentTypes = [.mpeg4Movie, .quickTimeMovie, .bundle]
        openPanel.message = "Please select the file types supported by CodeLume."
        openPanel.beginSheetModal(for: self.view.window!) { [weak self] (response) in
            guard let self = self, response == .OK, let sourceURL = openPanel.url else {
                return
            }
            self.tempSelectedFileURL = sourceURL
            print("choose file: \(sourceURL.lastPathComponent)")
        }
    }
    
    private func updateVersionLabel() {
        if let infoDictionary = Bundle(for: type(of: self)).infoDictionary {
            let version = infoDictionary["CFBundleShortVersionString"] as? String ?? "1.0"
            versionLabel.stringValue = "Version: \(version)"
        }
    }
}

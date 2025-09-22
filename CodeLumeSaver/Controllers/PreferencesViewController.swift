//
//  PreferencesViewController.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/19.
//

import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var typeComboBox: NSComboBox!
    @IBOutlet weak var selectButton: NSButtonCell!
    
    private let screensaverTypeKey = "CodeLumeScreensaverType"
    private let selectedFilePathKey = "CodeLumeSelectedFilePath"
    
    private var screensaverType: ScreensaverType {
        get {
            if let savedType = UserDefaults.standard.string(forKey: screensaverTypeKey),
               let type = ScreensaverType(rawValue: savedType) {
                return type
            }
            return .Video
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: screensaverTypeKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var selectedFilePath: String? {
        get {
            let fileManager = FileManager.default
            
            if let savedPath = UserDefaults.standard.string(forKey: selectedFilePathKey),
            fileManager.fileExists(atPath: savedPath) {
                return savedPath
            }
            
            self.selectedFilePath = copyDefaultVideoToSandbox()
            self.screensaverType = .Video
            return self.selectedFilePath
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedFilePathKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateComboBoxWithSavedType()
    }
    
    private func updateComboBoxWithSavedType() {
        if let comboBox = typeComboBox {
            let savedTypeString = screensaverType.rawValue
            let index = comboBox.indexOfItem(withObjectValue: savedTypeString)
            if index != -1 {
                comboBox.selectItem(at: index)
            }
        }
    }
    
    private func getSelectedScreensaverType() -> ScreensaverType {
        if let comboBox = typeComboBox,
           let selectedString = comboBox.objectValueOfSelectedItem as? String,
           let type = ScreensaverType(rawValue: selectedString) {
            return type
        }
        return .Video
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
    
    @IBAction func comboBoxSelectionChanged(_ sender: NSComboBox) {
        screensaverType = getSelectedScreensaverType()
    }
    
    @IBAction func selectButtonClicked(_ sender: NSButtonCell) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        
        switch screensaverType {
        case .Video:
            openPanel.allowedFileTypes = ["mp4", "mov"]
            openPanel.message = "choose video file"
        case .Sprite, .Scene:
            openPanel.allowedFileTypes = ["framework"]
            openPanel.message = screensaverType == .Sprite ? "choose sprite framework file" : "choose scene framework file"
        }
        
        openPanel.delegate = self
        
        openPanel.beginSheetModal(for: self.view.window!) { [weak self] (response) in
            guard let self = self, response == .OK, let sourceURL = openPanel.url else {
                return
            }
            
            if let destinationURL = copyFileToSandbox(sourceURL) {
                self.selectedFilePath = destinationURL.path
            }
        }
    }
}

extension PreferencesViewController: NSOpenSavePanelDelegate {
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        let fileName = url.lastPathComponent
        
        switch screensaverType {
        case .Sprite:
            return fileName.hasPrefix("codelume_sprite") && fileName.hasSuffix(".framework")
        case .Scene:
            return fileName.hasPrefix("codelume_scene") && fileName.hasSuffix(".framework")
        case .Video:
            return true
        }
    }
}

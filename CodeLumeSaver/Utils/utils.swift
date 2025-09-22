//
//  utils.swift
//  CodeLumeSaver
//
//  Created by lyke on 2025/9/22.
//

import Foundation

func getApplicationSupportDirectory() -> URL? {
    let fileManager = FileManager.default
    guard let appSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    let appDir = appSupportDir.appendingPathComponent("CodeLumeSaver", isDirectory: true)
    
    do {
        try fileManager.createDirectory(at: appDir, withIntermediateDirectories: true, attributes: nil)
        NSLog("Created application support directory: \(appDir.path)")
        return appDir
    } catch {
        print("Failed to create application support directory: \(error)")
        return nil
    }
}

func cleanupDestinationDirectory() {
    guard let destinationDir = getApplicationSupportDirectory() else {
        return
    }
    
    let fileManager = FileManager.default
    do {
        let contents = try fileManager.contentsOfDirectory(at: destinationDir, includingPropertiesForKeys: nil, options: [])
        for fileURL in contents {
            try fileManager.removeItem(at: fileURL)
        }
    } catch {
        print("Failed to clean up destination directory: \(error)")
    }
}

func copyFileToSandbox(_ sourceURL: URL) -> URL? {
    guard let destinationDir = getApplicationSupportDirectory() else {
        return nil
    }
    
    cleanupDestinationDirectory()
    
    let fileName = sourceURL.lastPathComponent
    let destinationURL = destinationDir.appendingPathComponent(fileName)
    
    let fileManager = FileManager.default
    do {
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        
        if fileName.hasSuffix(".framework") {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
        } else {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
        }
        
        return destinationURL
    } catch {
        print("Failed to copy file: \(error)")
        return nil
    }
}

func copyDefaultVideoToSandbox() -> String? {
    guard let defaultVideoURL = Bundle(for: PreferencesViewController.self).url(forResource: "codelume_1", withExtension: "mp4") else {
        print("Default video file not found in bundle")
        return nil
    }
    
    if let destinationURL = copyFileToSandbox(defaultVideoURL) {
        return destinationURL.path
    }
    
    return nil
}

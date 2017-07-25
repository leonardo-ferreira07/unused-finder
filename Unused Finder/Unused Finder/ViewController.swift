//
//  ViewController.swift
//  Unused Finder
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 24/07/17.
//  Copyright © 2017 iOS Wizards. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var loadUrlFile: URL!
    var swiftUrls: [URL]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func chooseTapped(_ sender: NSButton) {
        
        guard let window = view.window else { return }
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (result) in
            if result.rawValue == NSFileHandlingPanelOKButton {
                self.loadUrlFile = panel.urls[0]
//                print(self.loadUrlFile)
            }
        }
        
    }
    
    @IBAction func findTapped(_ sender: NSButton) {
        
        DispatchQueue.global(qos: .background).async {
            if self.loadUrlFile != nil {
                self.swiftUrls = []
                self.findAllFiles(with: self.loadUrlFile)
                print(self.swiftUrls)
                print(self.swiftUrls.count)
                
            }
        }
        
    }
    


}


// MARK: - File manager

extension ViewController {
    
    func contentsOf(folder: URL) -> [URL] {

        let fileManager = FileManager.default

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            
            let directoryContents = try fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            
//            let urls = contents.map {
//                return folder.appendingPathComponent($0)
//            }
            return directoryContents
        } catch {
            return []
        }
    }
    
    
    func findAllFiles(with url: URL) {
        
        var paths = self.contentsOf(folder: url).enumerated().reversed()
        
        for obj in paths {
            if !obj.element.absoluteString.contains(".") {
                // call again
                self.findAllFiles(with: obj.element)
            } else if obj.element.absoluteString.contains("Pods") {
                paths.remove(at: obj.offset)
            } else {
                if obj.element.absoluteString.contains(".swift") {
                    swiftUrls.append(obj.element)
                }
                paths.remove(at: obj.offset)
            }
            
        }
        
    }
    
    
}

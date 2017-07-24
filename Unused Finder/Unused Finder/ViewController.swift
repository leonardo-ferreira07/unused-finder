//
//  ViewController.swift
//  Unused Finder
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 24/07/17.
//  Copyright © 2017 iOS Wizards. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

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
//                self.selectedFolder = panel.urls[0]
                print(panel.urls[0])
                print(self.contentsOf(folder: panel.urls[0]))
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
            
            let urls = contents.map {
                return folder.appendingPathComponent($0)
            }
            return urls
        } catch {
            return []
        }
    }
    
}

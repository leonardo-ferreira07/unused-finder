//
//  Finder.swift
//  Unused Finder
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/07/17.
//  Copyright © 2017 iOS Wizards. All rights reserved.
//

import Foundation

struct Found {
    var swiftUrls: [URL]! = []
    var ibUrls: [URL]! = []
}

class Finder: NSObject {
    
    private var swiftUrls: [URL]! = []
    private var ibUrls: [URL]! = []
    
    func find(with url: URL, completion:@escaping (Found) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.swiftUrls = []
            self.ibUrls = []
            
            self.findAllFiles(with: url)
            
            // print swift code files
            print("count - \(self.swiftUrls)")
            print("count - \(self.swiftUrls.count)")
            
            for url in self.swiftUrls {
                do {
                    let text = try String(contentsOf: url, encoding: String.Encoding.utf8)
                    if let text = text.slice(from: "struct", to: "{") {
                        if let filtered = text.slice(from: " ", to: ":") {
                            print(filtered.replacingOccurrences(of: " ", with: ""))
                        } else {
                            print(text.replacingOccurrences(of: " ", with: ""))
                        }
                    } else if let text = text.slice(from: "class", to: "{") {
                        if !text.contains("(") {
                            if let filtered = text.slice(from: " ", to: ":") {
                                print(filtered.replacingOccurrences(of: " ", with: ""))
                            } else {
                                print(text.replacingOccurrences(of: " ", with: ""))
                            }
                        }
                    }
//                    print(text)
                } catch let errOpening as NSError {
                    print("Error! ", errOpening)
                }
            }
            
            // print interface builder files
            print("count - \(self.ibUrls)")
            print("count - \(self.ibUrls.count)")
            
            for url in self.ibUrls {
                do {
                    let text = try String(contentsOf: url, encoding: String.Encoding.utf8)
//                    print(text)
                } catch let errOpening as NSError {
                    print("Error! ", errOpening)
                }
            }
            
            // back to main thread and stop the animation
            DispatchQueue.main.async {
                completion(Found(swiftUrls: self.swiftUrls, ibUrls: self.ibUrls))
            }
        }
        
    }
    
}


// MARK: - File manager

extension Finder {
    
    private func contentsOf(folder: URL) -> [URL] {
        
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
    
    
    private func findAllFiles(with url: URL) {
        
        var paths = self.contentsOf(folder: url).enumerated().reversed()
        
        for obj in paths {
            if obj.element.pathExtension == "" || obj.element.pathExtension == "lproj" {
                // call again, because it found a folder
                self.findAllFiles(with: obj.element)
            } else if obj.element.absoluteString.contains("Pods") {
                paths.remove(at: obj.offset)
            } else {
                if obj.element.pathExtension == "swift" {
                    swiftUrls.append(obj.element)
                } else if obj.element.pathExtension == "xib" || obj.element.pathExtension == "storyboard" {
                    // search for interface builder files
                    ibUrls.append(obj.element)
                }
                paths.remove(at: obj.offset)
            }
            
        }
        
    }
    
    
}

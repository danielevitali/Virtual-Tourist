//
//  FileSystemManager.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/31/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class FileSystemManager {
    
    private static let instance = FileSystemManager()
    
    class func getInstance() -> FileSystemManager {
        return instance
    }
    
    private init(){}
    
    func savePhoto(fileName: String, imageData: NSData) -> String? {
        let directory = NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true).first!
        let path = directory.stringByAppendingString(fileName)
        let success = imageData.writeToFile(path, atomically: true)
        if !success {
            return nil
        }
        return path
    }
    
}
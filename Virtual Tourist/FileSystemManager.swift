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
    
    func savePhoto(fileName: String, imageData: NSData) {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let path = url.URLByAppendingPathComponent(fileName).path!
        imageData.writeToFile(path, atomically: true)
    }
    
    func getPhotoPath(photoId: String) -> String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent(photoId).path!
    }
    
    func deletePhoto(photoId: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(getPhotoPath(photoId))
        } catch {}
    }
    
}
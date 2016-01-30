//
//  MapRegion.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class MapRegion: NSObject, NSCoding {
    
    private static let KEY_ORIGIN_X = "KEY_ORIGIN_X"
    private static let KEY_ORIGIN_Y = "KEY_ORIGIN_Y"
    private static let KEY_WIDTH = "KEY_WIDTH"
    private static let KEY_HEIGHT = "KEY_HEIGHT"
    
    let originX: Double
    let originY: Double
    let width: Double
    let height: Double
    
    init(originX: Double, originY: Double, width: Double, height: Double) {
        self.originX = originX
        self.originY = originY
        self.width = width
        self.height = height
    }
    
    required init(coder unarchiver: NSCoder) {
        originX = unarchiver.decodeObjectForKey(MapRegion.KEY_ORIGIN_X) as! Double
        originY = unarchiver.decodeObjectForKey(MapRegion.KEY_ORIGIN_Y) as! Double
        width = unarchiver.decodeObjectForKey(MapRegion.KEY_WIDTH) as! Double
        height = unarchiver.decodeObjectForKey(MapRegion.KEY_HEIGHT) as! Double
    }
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(originX, forKey: MapRegion.KEY_ORIGIN_X)
        archiver.encodeObject(originY, forKey: MapRegion.KEY_ORIGIN_Y)
        archiver.encodeObject(width, forKey: MapRegion.KEY_WIDTH)
        archiver.encodeObject(height, forKey: MapRegion.KEY_HEIGHT)
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if !(object is MapRegion) {
            return false
        }
        let otherRegion = (object as! MapRegion)
        return originX == otherRegion.originX && originY == otherRegion.originY && width == otherRegion.width && height == otherRegion.height
    }
}

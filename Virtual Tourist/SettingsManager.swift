//
//  Settings.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

class SettingsManager {
    
    private static let KEY_MAP_REGION = "KEY_MAP_REGION"
    
    class func getMapRegion() -> MapRegion? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.dataForKey(KEY_MAP_REGION) {
            return (NSKeyedUnarchiver.unarchiveObjectWithData(data) as! MapRegion)
        }
        return nil
    }
    
    class func setMapRegion(region: MapRegion) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(region)
        userDefaults.setObject(data, forKey: KEY_MAP_REGION)
    }
}

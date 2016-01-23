//
//  DataManager.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

class DataManager {
    
    private static let instance: DataManager = DataManager()
    
    private var currentMapRegion: MapRegion?
    
    static func getInstance() -> DataManager {
        return instance
    }
    
    func getLastMapRegion() -> MapRegion? {
        currentMapRegion = Settings.getMapRegion()
        return currentMapRegion
    }
    
    func setLastMapRegion(region: MapRegion) {
        if currentMapRegion != region {
            Settings.setMapRegion(region)
            currentMapRegion = region
        }
    }
}
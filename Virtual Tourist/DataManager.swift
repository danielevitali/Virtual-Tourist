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
    
    static let instance: DataManager = DataManager()
    
    static func getInstance() -> DataManager {
        return instance
    }
    
    func getLastMapZoomLevel() -> Double {
        return Settings.getMapZoomLevel()
    }
    
    func getLastMapCoordinates() -> CLLocationCoordinate2D? {
        return Settings.getMapCoordinates()
    }
    
    func setLastMapZoomLevel(zoom: Double) {
        Settings.putMapZoomLevel(zoom)
    }
    
    func setLastMapCoordinates(coordinates: CLLocationCoordinate2D) {
        Settings.putMapCoordinates(coordinates)
    }
}
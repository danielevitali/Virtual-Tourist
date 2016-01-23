//
//  Settings.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

class Settings {
    
    private static let KEY_MAP_ZOOM = "KEY_MAP_ZOOM"
    private static let KEY_MAP_LATITUDE = "KEY_MAP_LATITUDE"
    private static let KEY_MAP_LONGITUDE = "KEY_MAP_LONGITUDE"
    
    private static let DEFAULT_ZOOM_LEVEL = 10.0
    
    static func getMapZoomLevel() -> Double {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let zoom = userDefaults.objectForKey(KEY_MAP_ZOOM) {
            return (zoom as! Double)
        }
        return DEFAULT_ZOOM_LEVEL
    }
    
    static func getMapCoordinates() -> CLLocationCoordinate2D? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let latitude = userDefaults.objectForKey(KEY_MAP_LATITUDE), let longitude = userDefaults.objectForKey(KEY_MAP_LONGITUDE) {
            return CLLocationCoordinate2D(latitude: (latitude as! Double), longitude: (longitude as! Double))
        }
        return nil
    }
    
    static func putMapZoomLevel(zoom: Double) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setDouble(zoom, forKey: KEY_MAP_ZOOM)
    }
    
    static func putMapCoordinates(coordinates: CLLocationCoordinate2D) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setDouble(coordinates.latitude, forKey: KEY_MAP_LATITUDE)
        userDefaults.setDouble(coordinates.longitude, forKey: KEY_MAP_LONGITUDE)
    }
}
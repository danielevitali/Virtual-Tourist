//
//  File.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 2/14/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    
    var location: Location?
    let coordinate: CLLocationCoordinate2D
    
    init(latitude: Double, longitude: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
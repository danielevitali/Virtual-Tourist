//
//  TravelLocationsMapView.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

protocol TravelLocationsMapContractView {
    
    var presenter: TravelLocationsMapContractPresenter! {get set}
 
    func showMapRegion(region: MapRegion)
    
    func addPin(pin: Pin)
    
    func removePin(pin: Pin)
    
    func showPhotoAlbum(location: Location)
    
    func showPins(pins: [Pin])
    
    func showError(message: String)
    
}
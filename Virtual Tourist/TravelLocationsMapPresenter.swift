//
//  TravelLocationsMapPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class TravelLocationsMapPresenter: TravelLocationsMapContractPresenter {
    
    let view: TravelLocationsMapContractView
    
    var locations: [Location]
    var droppingPin: Pin!
    
    init(view: TravelLocationsMapContractView) {
        self.view = view
        
        if let region = DataManager.getInstance().getLastMapRegion() {
            view.showMapRegion(region)
        }
        if let locations = DataManager.getInstance().getLocations() {
            self.locations = locations
            var pins = [Pin]()
            for location in locations {
                let pin = Pin(latitude: location.latitude as Double, longitude: location.longitude as Double)
                pin.location = location
                pins.append(pin)
            }
            view.showPins(pins)
        } else {
            self.locations = [Location]()
            view.showError("Error loading pins on map")
        }
    }
    
    func onMapRegionChanged(region: MapRegion) {
        DataManager.getInstance().setLastMapRegion(region)
    }
    
    func onLongClickOnMapBegin(latitude: Double, longitude: Double) {
        droppingPin = Pin(latitude: latitude, longitude: longitude)
        view.addPin(droppingPin)
    }
    
    func onLongClickOnMapEnd() {
        let location = DataManager.getInstance().createLocation(droppingPin.coordinate.latitude, longitude: droppingPin.coordinate.longitude)
        droppingPin.location = location
        DataManager.getInstance().searchPhotos(location)
        view.showPhotoAlbum(location)
    }
    
    func onPinClick(pin: Pin) {
        view.showPhotoAlbum(pin.location!)
    }
    
}
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
    
    var locations: [Location]!
    var droppingAnnotation: MKAnnotationView!
    
    init(view: TravelLocationsMapContractView) {
        self.view = view
        
        if let region = DataManager.getInstance().getLastMapRegion() {
            view.showMapRegion(region)
        }
        if let locations = DataManager.getInstance().getLocations() {
            self.locations = locations
            view.showPins(locations)
        } else {
            self.locations = [Location]()
            view.showError("Error loading pins on map")
        }
    }
    
    func onMapRegionChanged(region: MapRegion) {
        DataManager.getInstance().setLastMapRegion(region)
    }
    
    func onLongClickOnMapBegin(latitude: Double, longitude: Double) {
        droppingAnnotation = view.addPin(latitude, longitude: longitude, draggable: true)
    }
    
    func onLongClickOnMapEnd() {
        let coordinate = droppingAnnotation.annotation!.coordinate
        let location = DataManager.getInstance().createLocation(coordinate.latitude, longitude: coordinate.longitude)
        DataManager.getInstance().searchPhotos(location)
        view.showPhotoAlbum(location)
    }
    
    func onPinClick(pin: MKAnnotationView) {
        for location in locations {
            if location.pin == pin {
                view.showPhotoAlbum(location)
                break;
            }
        }
    }
    
}
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
    
    init(view: TravelLocationsMapContractView) {
        self.view = view

    }
    
    func onViewVisible() {
        if let region = DataManager.getInstance().getLastMapRegion() {
            view.showMapRegion(region)
        }
        if let pins = DataManager.getInstance().getPins() {
            view.showPins(pins)
        } else {
            view.showError("Error loading pins on map")
        }
    }
    
    func onViewHidden() {
        
    }
    
    func onMapRegionChanged(region: MapRegion) {
        DataManager.getInstance().setLastMapRegion(region)
    }
    
    func onDataChange(pin: Pin, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            view.addPin(pin)
            view.showPhotoAlbum(pin)
        case .Delete:
            view.removePin(pin)
        default: break
        }
    }
    
    func onLongClickOnMap(latitude: Double, longitude: Double) {
        DataManager.getInstance().createPin(latitude, longitude: longitude)
    }
    
    func onPinClick(pin: Pin) {
        view.showPhotoAlbum(pin)
    }
    
}
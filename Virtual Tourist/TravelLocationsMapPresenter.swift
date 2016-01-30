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
    var pins: [Pin]
    
    init(view: TravelLocationsMapContractView) {
        self.view = view
        pins = [Pin]()
    }
    
    func onViewVisible() {
        if let region = DataManager.getInstance().getLastMapRegion() {
            view.showMapRegion(region)
        }
        DataManager.getInstance().getPins(view)
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
        case .Delete:
            view.removePin(pin)
        default: break
        }
    }
    
}
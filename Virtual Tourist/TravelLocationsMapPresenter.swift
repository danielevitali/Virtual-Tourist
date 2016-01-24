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
        DataManager.getInstance().getPins(view)
    }
    
    func onViewHidden() {
        
    }
    
    func onMapRegionChanged(region: MapRegion) {
        DataManager.getInstance().setLastMapRegion(region)
    }
    
    func onDataChange(type: NSFetchedResultsChangeType, pinChanged pin: Pin) {
        switch type {
        case .Insert:
            view.addPin(pin)
        case .Delete:
            view.removePin(pin)
        case .Move:
            view.removePin(pin)
            view.addPin(pin)
        default: break
        }
    }
    
}
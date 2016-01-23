//
//  TravelLocationsMapPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

class TravelLocationsMapPresenter: TravelLocationsMapContractPresenter {
    
    let view: TravelLocationsMapContractView
    
    init(view: TravelLocationsMapContractView) {
        self.view = view
    }
    
    func onViewVisible() {
        if let region = DataManager.getInstance().getLastMapRegion() {
            view.showMapRegion(region)
        }
    }
    
    func onViewHidden() {
        
    }
    
    func onMapRegionChanged(region: MapRegion) {
        DataManager.getInstance().setLastMapRegion(region)
    }
}
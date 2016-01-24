//
//  TravelLocationsMapContractPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

protocol TravelLocationsMapContractPresenter {
    
    var view: TravelLocationsMapContractView {get}

    func onViewVisible()
    
    func onViewHidden()
    
    func onMapRegionChanged(region: MapRegion)
    
    func onDataChange(type: NSFetchedResultsChangeType, oldIndexPath: NSIndexPath?, newIndexPath: NSIndexPath?)
}
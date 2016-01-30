//
//  DataManager.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class DataManager {
    
    private static let instance: DataManager = DataManager()
    
    private let coreDataStackManager: CoreDataStackManager
    private var currentMapRegion: MapRegion?
    
    lazy var fetchedPinsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStackManager.getInstance().managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    class func getInstance() -> DataManager {
        return instance
    }
    
    init() {
        self.coreDataStackManager = CoreDataStackManager.getInstance()
    }
    
    func getLastMapRegion() -> MapRegion? {
        if let currentMapRegion = currentMapRegion {
            return currentMapRegion
        } else {
            currentMapRegion = SettingsManager.getMapRegion()
            return currentMapRegion
        }
    }
    
    func setLastMapRegion(region: MapRegion) {
        if currentMapRegion != region {
            SettingsManager.setMapRegion(region)
            currentMapRegion = region
        }
    }
    
    func getPins(delegate: NSFetchedResultsControllerDelegate?) {
        fetchedPinsController.delegate = delegate
        do {
            try fetchedPinsController.performFetch()
        } catch {}
    }
    
    func createPin(latitude: Double, longitude: Double) -> Pin {
        let pin = Pin(latitude: latitude, longitude: longitude, context: coreDataStackManager.managedObjectContext)
        coreDataStackManager.saveContext()
        return pin
    }
    
    func searchPhotos(pin: Pin, photosCountCallback: (count: Int?, errorMessage: String?) -> Void, photosCallback: (photos: [Photo]?, errorMessage: String?) -> Void) {
        NetworkManager.getInstance().searchPhotos(pin.latitude as Double, longitude: pin.longitude as Double, callback: { (photosResponse, errorResponse) in
            if let photosResponse = photosResponse {
                photosCountCallback(count: photosResponse.photos.count, errorMessage: nil)

                //TODO download and save photos
                //photosCallback(photos: photos, errorMessage: nil)
            } else {
                photosCountCallback(count: nil, errorMessage: errorResponse!.message)
            }
        })
    }
}

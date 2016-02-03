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
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataStackManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
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
    
    func getPins() -> [Pin]? {
        do {
            try fetchedPinsController.performFetch()
            return fetchedPinsController.sections![0].objects as? [Pin]
        } catch {}
        return nil
    }
    
    func createPin(latitude: Double, longitude: Double) -> Pin {
        let pin = Pin(latitude: latitude, longitude: longitude, context: coreDataStackManager.managedObjectContext)
        coreDataStackManager.saveContext()
        return pin
    }
    
    func searchPhotos(pin: Pin, delegate: NSFetchedResultsControllerDelegate?, errorCallback: (errorMessage: String) -> Void) {
        NetworkManager.getInstance().searchPhotos(pin.latitude as Double, longitude: pin.longitude as Double, callback: { (photosResponse, errorResponse) in
            if let photosResponse = photosResponse {
                for photoResponse in photosResponse.photos {
                    let photo = Photo(photoResponse: photoResponse, context: self.coreDataStackManager.managedObjectContext)
                    pin.album.removeAll()
                    pin.album.append(photo)
                    NetworkManager.getInstance().downloadPhoto(NSURL(string: photoResponse.url)!, callback: { (imageData, errorResponse) -> Void in
                        if let imageData = imageData {
                            photo.path = FileSystemManager.getInstance().savePhoto(photo.id, imageData: imageData)
                        } else {
                            pin.album.removeAtIndex((pin.album.indexOf(photo))!)
                        }
                        self.coreDataStackManager.saveContext()
                    })
                }
                self.coreDataStackManager.saveContext()
            } else {
                errorCallback(errorMessage: errorResponse!.message)
            }
        })
    }
}

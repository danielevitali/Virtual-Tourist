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
    
    let coreDataStackManager: CoreDataStackManager
    private var currentMapRegion: MapRegion?
    
    lazy var fetchedLocationsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Location")
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
    
    func getLocations() -> [Location]? {
        do {
            try fetchedLocationsController.performFetch()
            return fetchedLocationsController.sections![0].objects! as? [Location]
        } catch {
            print("Error info: \(error)")
        }
        return nil
    }
    
    func createLocation(latitude: Double, longitude: Double) -> Location {
        let location = Location(latitude: latitude, longitude: longitude, context: coreDataStackManager.managedObjectContext)
        coreDataStackManager.saveContext()
        return location
    }
    
    func searchPhotos(location: Location) {
        let page: Int
        if let totalPagesCount = location.totalPagesCount as? Int{
            page = Int(arc4random_uniform(UInt32(totalPagesCount)))
        } else {
            page = 0
        }
        
        NetworkManager.getInstance().searchPhotos(location.latitude as Double, longitude: location.longitude as Double, page: page, callback: { (photosResponse, errorResponse) in
            dispatch_async(dispatch_get_main_queue(), {
                if let photosResponse = photosResponse {
                    print("Downloaded \(photosResponse.photos.count) photos entities")
                    location.totalPagesCount = photosResponse.pages
                    for photoResponse in photosResponse.photos {
                        let photo = Photo(photoResponse: photoResponse, context: self.coreDataStackManager.managedObjectContext)
                        photo.location = location
                        NetworkManager.getInstance().downloadPhoto(NSURL(string: photoResponse.url)!, callback: { (imageData, errorResponse) -> Void in
                            dispatch_async(dispatch_get_main_queue(), {
                                if let imageData = imageData {
                                    photo.path = FileSystemManager.getInstance().savePhoto(photo.id, imageData: imageData)
                                    print("Saved photo \(photo.id)")
                                } else {
                                    print("Removed photo \(photo.id)")
                                    self.coreDataStackManager.deleteObject(photo)
                                }
                                self.coreDataStackManager.saveContext()
                            })
                        })
                    }
                    self.coreDataStackManager.saveContext()
                }
            })
        })
    }
}

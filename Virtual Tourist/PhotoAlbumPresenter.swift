//
//  PhotoAlbumPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData

class PhotoAlbumPresenter: PhotoAlbumContractPresenter {
    
    let view: PhotoAlbumContractView    
    let location: Location
    
    lazy var fetchedPhotosController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "location = %@", self.location)
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.getInstance().coreDataStackManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController
    }()
    
    init(view: PhotoAlbumContractView, location: Location) {
        self.view = view
        self.location = location
        self.fetchedPhotosController.delegate = view
    }
    
    func onViewVisible() {
        view.showPin(location, span: 1000)
        
        view.toggleActivityIndicator(true)
        view.hidePhotos()
        view.toggleNewCollectionButton(false)
        
        do {
            try fetchedPhotosController.performFetch()
        } catch {}
        
        if let photos = fetchedPhotosController.fetchedObjects where !photos.isEmpty {
            view.reloadPhotos()
            view.showPhotos()
            view.toggleNewCollectionButton(true)
        }
    }
    
    func onViewHidden() {
        
    }
    
    func photosUpdate() {
        if let photos = fetchedPhotosController.fetchedObjects as? [Photo] {
            for photo in photos {
                if photo.fileName == nil {
                    view.toggleNewCollectionButton(false)
                    return
                }
            }
            view.toggleNewCollectionButton(true)
        }
    }
    
    func onNewCollectionClick() {
        view.toggleActivityIndicator(true)
        view.hidePhotos()
        view.toggleNewCollectionButton(false)
        
        if let photos = fetchedPhotosController.fetchedObjects as? [Photo] {
            for photo in photos {
                DataManager.getInstance().coreDataStackManager.deleteObject(photo)
            }
        }
        
        DataManager.getInstance().coreDataStackManager.saveContext()
        DataManager.getInstance().searchPhotos(location)
    }
    
    func onPhotoClick(photo: Photo) {
        DataManager.getInstance().coreDataStackManager.deleteObject(photo)
        DataManager.getInstance().coreDataStackManager.saveContext()
    }
}
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
    let pin: Pin
    
    lazy var fetchedPhotosController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        //fetchRequest.predicate = NSPredicate(format: "pin.id = '\(self.pin.id)'")
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.getInstance().coreDataStackManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController
    }()
    
    init(view: PhotoAlbumContractView, pin: Pin) {
        self.view = view
        self.pin = pin
        self.fetchedPhotosController.delegate = view
    }
    
    func onViewVisible() {
        view.showPin(pin, span: 1000)
        
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
                if photo.path == nil {
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
                photo.deletePhotoFile()
                DataManager.getInstance().coreDataStackManager.deleteObject(photo)
            }
        }
        DataManager.getInstance().coreDataStackManager.saveContext()
        DataManager.getInstance().searchPhotos(pin)
    }
    
    func onPhotoClick(photo: Photo) {
        photo.deletePhotoFile()
        DataManager.getInstance().coreDataStackManager.deleteObject(photo)
        DataManager.getInstance().coreDataStackManager.saveContext()
    }
}
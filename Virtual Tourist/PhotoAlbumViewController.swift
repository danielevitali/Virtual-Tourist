//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, PhotoAlbumContractView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var photosFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var lblNoImages: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnNewCollection: UIButton!
    
    var presenter: PhotoAlbumContractPresenter!
    var selectedPin: Pin!
    
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PhotoAlbumPresenter(view: self, pin: selectedPin)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let itemSpace: CGFloat = 3.0
        let itemSize = (view.frame.size.width - 3 * itemSpace) / 3
        photosFlowLayout.minimumInteritemSpacing = itemSpace
        photosFlowLayout.minimumLineSpacing = itemSpace
        photosFlowLayout.itemSize = CGSizeMake(itemSize, itemSize)
        photosCollection.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewVisible()
    }
    
    @IBAction func onNewCollectionClick(sender: AnyObject) {
        presenter.onNewCollectionClick()
    }
    
    func showPin(pin: Pin, span: Double) {
        mapView.removeAnnotations(mapView.annotations)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate, span, span)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.addAnnotation(pin)
    }
    
    func showPhotos() {
        if presenter.fetchedPhotosController.fetchedObjects?.count ?? 0 > 0 {
            photosCollection.hidden = false
            lblNoImages.hidden = true
        } else {
            photosCollection.hidden = true
            lblNoImages.hidden = false
        }
    }
    
    func hidePhotos() {
        photosCollection.hidden = true
        lblNoImages.hidden = true
    }
    
    func toggleActivityIndicator(visible: Bool) {
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(message: String) {
        ErrorAlert(message: message).show(self)
    }
    
    func toggleNewCollectionButton(enable: Bool) {
        btnNewCollection.enabled = enable
    }
    
    func reloadPhotos() {
        photosCollection.reloadData()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
            switch type {
            case .Insert:
                self.photosCollection.insertSections(NSIndexSet(index: sectionIndex))
            case .Delete:
                self.photosCollection.deleteSections(NSIndexSet(index: sectionIndex))
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        photosCollection.performBatchUpdates({() -> Void in
            
            if self.photosCollection.numberOfSections() == 0 {
                self.photosCollection.insertSections(NSIndexSet(index: 0))
            }
            
            for indexPath in self.insertedIndexPaths {
                self.photosCollection.insertItemsAtIndexPaths([indexPath])
                self.presenter.photosUpdate()
                self.showPhotos()
                self.toggleActivityIndicator(false)
            }
            
            for indexPath in self.deletedIndexPaths {
                self.photosCollection.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.photosCollection.reloadItemsAtIndexPaths([indexPath])
                self.presenter.photosUpdate()
            }
            
            }, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return presenter.fetchedPhotosController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = presenter.fetchedPhotosController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as! PhotoCell
        let photo = presenter.fetchedPhotosController.objectAtIndexPath(indexPath) as! Photo
        cell.showPhoto(photo)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = presenter.fetchedPhotosController.objectAtIndexPath(indexPath) as! Photo
        presenter.onPhotoClick(photo)
    }
    
}
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PhotoAlbumPresenter(view: self, pin: selectedPin)
        
        let itemSpace: CGFloat = 3.0
        let itemSize = (view.frame.size.width - 3 * itemSpace) / 3
        photosFlowLayout.minimumInteritemSpacing = itemSpace
        photosFlowLayout.minimumLineSpacing = itemSpace
        photosFlowLayout.itemSize = CGSizeMake(itemSize, itemSize)
        photosCollection.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewVisible()
    }
    
    func showPin(pin: Pin, span: Double) {
        mapView.removeAnnotations(mapView.annotations)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate, span, span)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.addAnnotation(pin)
    }
    
    func showPhotos() {
        photosCollection.reloadData()
        if presenter.pin.album.count > 0 {
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let photo = anObject as! Photo
        presenter.photosChanged(photo, changeType: type, fromIndexPath: indexPath, toIndexPath: newIndexPath)
    }
    
    func addPhoto(indexPath: NSIndexPath) {
        photosCollection.insertItemsAtIndexPaths([indexPath])
    }
    
    func removePhoto(indexPath: NSIndexPath) {
        photosCollection.deleteItemsAtIndexPaths([indexPath])
    }
    
    func movePhoto(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        removePhoto(fromIndexPath)
        addPhoto(toIndexPath)
    }
    
    func updatePhoto(photo: Photo, indexPath: NSIndexPath) {
        let cell = photosCollection.cellForItemAtIndexPath(indexPath) as! PhotoCell
        cell.showPhoto(photo)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.pin.album.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as! PhotoCell
        cell.showPhoto(presenter.pin.album[indexPath.row])
        return cell
    }
    
}
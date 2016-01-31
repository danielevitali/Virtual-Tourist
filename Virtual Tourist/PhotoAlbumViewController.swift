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
    
    func hideAlbum() {
        photosCollection.hidden = true
        lblNoImages.hidden = true
    }
    
    func showAlbum(photosCount: Int) {
        if photosCount > 0 {
            photosCollection.hidden = false
            lblNoImages.hidden = true
            photosCollection.reloadData()
        } else {
            photosCollection.hidden = true
            lblNoImages.hidden = false
        }
    }
    
    func toggleNewCollectionButton(enable: Bool) {
        btnNewCollection.enabled = enable
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = presenter.photosCount {
            return count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as! PhotoCell
        cell.showPlaceholder()
        return cell
    }
    
}
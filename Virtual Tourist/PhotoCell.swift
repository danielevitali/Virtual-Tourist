//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func showPhoto(photo: Photo) {
        if let path = photo.path {
            imageView.image = UIImage(contentsOfFile: path)
            print("Show photo \(photo.id)")
        } else {
            imageView.image = UIImage(named: "photo_placeholder")
            print("Show placeholder for photo \(photo.id)")
        }
    }
}
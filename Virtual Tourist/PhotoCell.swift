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
    
    func showPlaceholder() {
        imageView.image = UIImage(named: "photo_placeholder")
    }
    
}
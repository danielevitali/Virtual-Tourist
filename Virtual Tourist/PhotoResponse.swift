//
//  File.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class PhotoResponse {
    
    let id: String
    let url: String
    
    init(response: NSDictionary) {
        self.id = response["id"] as! String
        self.url = response["url_m"] as! String
    }
    
}
//
//  ErrorResponse.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class ErrorResponse {
    
    let code: Int
    let message: String
    let status: String
    
    init(response: NSDictionary) {
        self.code = response["code"] as! Int
        self.message = response["message"] as! String
        self.status = response["stat"] as! String
    }
    
    init(error: NSError) {
        self.code = -1
        self.message = error.localizedDescription
        self.status = ""
    }
    
}
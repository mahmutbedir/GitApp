//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Mac on 26.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

class Placemodel {
    
    static let sharedInstance = Placemodel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    
    private init () {}
}

//
//  MusicianClass.swift
//  AdvancedSwiftProject
//
//  Created by Mac on 16.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class Musician {
    var name : String
    var age : Int
    var instrument : String
    
    init(nameInput : String, ageInput : Int, instrumentInput : String) {
        self.name = nameInput
        self.age = ageInput
        self.instrument = instrumentInput
    }
}

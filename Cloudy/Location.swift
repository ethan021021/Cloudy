//
//  Location.swift
//  Cloudy
//
//  Created by Ethan Thomas on 9/13/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() { }
    
    var latitude: Double!
    var longitude: Double!
}

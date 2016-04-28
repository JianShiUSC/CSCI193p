//
//  MKGPX.swift
//  Trax
//
//  Created by 淡蓝色的泪 on 4/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import MapKit

extension GPX.Waypoint: MKAnnotation
{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return name }
    
    var subtitle: String? { return info }
}

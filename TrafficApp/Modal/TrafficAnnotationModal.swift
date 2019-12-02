//
//  TrafficAnnotationModal.swift
//  TrafficApp
//
//  Created by Umang Davessar on 2/12/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import MapKit

class TrafficAnnotationModal: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var cameraID: String!
    var timeStamp: String!
    var image: String!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

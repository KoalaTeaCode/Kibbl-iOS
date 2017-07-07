//
//  LocationManager.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/31/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import CoreLocation
import AddressBookUI

class LocationManager {
    //@TODO: Add function to calculate distance in miles between two locations
    class func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if let error = error {
                log.error(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                //                if (placemark?.areasOfInterest?.count)! > 0 {
                //                    let areaOfInterest = placemark!.areasOfInterest![0]
                //                    print(areaOfInterest)
                //                } else {
                //                    print("No area of interest found.")
                //                }
            }
        })
    }

}

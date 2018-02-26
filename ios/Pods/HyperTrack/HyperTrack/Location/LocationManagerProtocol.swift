//
//  LocationManagerProtocol.swift
//  HyperTrack
//
//  Created by ravi on 11/27/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerProtocol: class {

    var locationEventsDelegate: LocationEventsDelegate? { get set }
    var eventDelegate: HTEventsDelegate? { get set }

    func startTracking(completionHandler: ((_ error: HyperTrackError?) -> Void)?)
    
    func stopTracking()
    
    func requestWhenInUseAuthorization()
    
    func requestAlwaysAuthorization()
    
    func requestAlwaysAuthorization(completionHandler: @escaping (_ isAuthorized: Bool) -> Void)

    func getLocationFromLookUpId(lookUpId: String) -> HyperTrackLocation?
    
    func getLastKnownLocation() -> CLLocation?
    
    func getLastKnownHyperTrackLocation() -> HyperTrackLocation?

    func startMonitoringForEntryAtPlace(place: HyperTrackPlace, radius: CLLocationDistance, identifier: String)
    
    func startMonitoringExitForLocation(location: CLLocation, identifier: String)


    func getCurrentLocation(completionHandler: @escaping (_ currentLocation: CLLocation?, _ error: HyperTrackError?) -> Void)
    
    func requestLocation()

   func updateLocationManager(filterDistance: CLLocationDistance, pausesLocationUpdatesAutomatically: Bool)
    
    func didChangeActivityTo(activity: HTSDKActivity, fromActivity: HTSDKActivity?) 

}

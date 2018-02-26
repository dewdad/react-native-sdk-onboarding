//
//  HypertrackService.swift
//  HyperTrack
//
//  Created by Ravi Jain on 8/5/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import UIKit
import CoreLocation
import CocoaLumberjack
//import Sentry

class HypertrackService: NSObject {

    static let sharedInstance = HypertrackService()

    let requestManager: RequestManager
    let pushNotificationService: PushNotificationService
    var hasTrackingStarted = false
    
    override init() {
        self.requestManager = RequestManager()
        self.pushNotificationService = PushNotificationService()
        super.init()
        self.pushNotificationService.delegate = self
    }

    func setPublishableKey(publishableKey: String) {
        Settings.setPublishableKey(publishableKey: publishableKey)
        initializeSentry()
        initialize()
    }

    func getPublishableKey() -> String? {
        return Settings.getPublishableKey()
    }
    
    var isTracking: Bool {
        get {
            return Settings.getTracking()
        }
    }
    
    var isMockTracking: Bool {
        get {
            return Settings.getMockTracking()
        }
    }
    
    func initializeSentry(){
//        // Create a Sentry client and start crash handler
//        do {
//            Client.shared = try Client(dsn: "https://4ae0bb082d3542c38e6e217274545356:dcc72e9b7a814c88a20bed51207febb3@sentry.io/114935")
//            try Client.shared?.startCrashHandler()
//        } catch let error {
//            print("\(error)")
//            // Wrong DSN or KSCrash not installed
//        }
    }
    
    func canStartTracking(completionHandler: ((_ error: HyperTrackError?) -> Void)?) -> Bool {
        if (HTUserService.sharedInstance.userId == nil) {
            DDLogError("Can't start tracking. Need userId.")
            let error = HyperTrackError(HyperTrackErrorType.userIdError)
            guard let completionHandler = completionHandler else { return false }
            completionHandler(error)
            return false
        } else if (Settings.getPublishableKey() == nil) {
            DDLogError("Can't start tracking. Need publishableKey.")
            let error = HyperTrackError(HyperTrackErrorType.publishableKeyError)
            guard let completionHandler = completionHandler else { return false }
            completionHandler(error)
            return false
        }
        return true
    }
    
    func initialize() {
        HTLogger.shared.initialize()
        DDLogInfo("Initialize transmitter")
        if self.isTracking {
            self.startTracking(completionHandler: nil)
        }
    }
    
    func startTracking(completionHandler: ((_ error: HyperTrackError?) -> Void)?) {
        
        if !canStartTracking(completionHandler: completionHandler) {
            return
        }
        
        if isMockTracking {
            // If mock tracking is active, the normal tracking flow will
            // not continue and throw an error.
            // TODO: better error message
            guard let completionHandler = completionHandler else { return }
            let error = HyperTrackError(HyperTrackErrorType.invalidParamsError)
            completionHandler(error)
            return
        }
       
        if !hasTrackingStarted{
            if !Settings.getTracking() {
                HTSDKDataManager.sharedInstance.locationManager.requestLocation()
            }
            
            HTSDKDataManager.sharedInstance.startTracking(completionHandler: completionHandler)
            HTSDKControlsService.sharedInstance.setUpControls()
            HTTransmissionService.sharedInstance.setUpTransmissionControls()
            hasTrackingStarted = true
            guard let completionHandler = completionHandler else { return }
            completionHandler(nil)
        }else{
            guard let completionHandler = completionHandler else { return }
            completionHandler(nil)
        }
    }
    
    func startMockTracking(origin: CLLocationCoordinate2D? = nil, destination: CLLocationCoordinate2D? = nil, completionHandler: ((_ error: HyperTrackError?) -> Void)?) {
        
        if !canStartTracking(completionHandler: completionHandler) {
            return
        }
        
        if isTracking {
            // If tracking is active, the mock tracking will
            // not continue and throw an error.
            guard let completionHandler = completionHandler else { return }
            let error = HyperTrackError(HyperTrackErrorType.invalidParamsError)
            completionHandler(error)
            return
        }
        
        if !hasTrackingStarted{
            hasTrackingStarted = true
            HTSDKDataManager.sharedInstance.startMockTracking(origin: origin, destination: destination
                , completionHandler: completionHandler)
        }
    }
    
    func stopMockTracking() {
        hasTrackingStarted = false
        HTSDKDataManager.sharedInstance.stopMockTracking()
    }
    
    func stopTracking(completionHandler: ((_ error: HyperTrackError?) -> Void)?) {
        hasTrackingStarted = false
        HTSDKDataManager.sharedInstance.stopTracking()
        if let completionBlock = completionHandler{
            completionBlock(nil)
        }
    }
}

extension HypertrackService: PushNotificationDelegate{
    
    func didRecieveNotificationForSDKControls(){
        HTSDKControlsService.sharedInstance.onServerNotification()
    }
}

extension HypertrackService {
    
    func findPlaces(searchText: String?, cordinate: CLLocationCoordinate2D?, completionHandler: ((_ places: [HyperTrackPlace]?, _ error: HyperTrackError?) -> Void)?) {
        self.requestManager.findPlaces(searchText: searchText, cordinate: cordinate, completionHandler: completionHandler)
    }
    
    func createPlace(geoJson: HTGeoJSONLocation, completionHandler: ((_ place: HyperTrackPlace?, _ error: HyperTrackError?) -> Void)?) {
        self.requestManager.createPlace(geoJson: geoJson, completionHandler: completionHandler)
    }
    
    func getETA(expectedPlaceCoordinates: CLLocationCoordinate2D, vehicleType: String?,
                completionHandler: @escaping (_ eta: NSNumber?, _ error: HyperTrackError?) -> Void) {
        var vehicleTypeParam = vehicleType
        if vehicleTypeParam == nil {
            vehicleTypeParam = "car"
        }
        
        HTSDKDataManager.sharedInstance.getCurrentLocation { (currentLocation, error) in
            if currentLocation != nil {
                self.requestManager.getETA(currentLocationCoordinates: currentLocation!.coordinate,
                                           expectedPlaceCoordinates: expectedPlaceCoordinates,
                                           vehicleType: vehicleTypeParam!,
                                           completionHandler: completionHandler)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}

//
//  Hypertrack.swift
//  HyperTrack
//
//  Created by Pratik Naik on 2/17/17.
//  Copyright © 2017 Pratik Naik. All rights reserved.
//

import Foundation
import MapKit
import CoreMotion

/**
 HyperTrack is the easiest way to build live location features in your application. The SDK is built to collect accurate location data with battery efficiency. The SDK has methods to start and stop tracking, and implement use-cases like order tracking, mileage tracking. For more information, visit http://docs.hypertrack.com
 */
@objc public class HyperTrack:NSObject {
    
    /**
     Call this method to set a HyperTrackDelegate. This allows you to receive events and errors as they occur.
     
     - Parameter delegate: The delegate that receives errors and events
     */
    @objc public class func setDelegate(_ delegate:HyperTrackDelegate? = nil) {
        Transmitter.sharedInstance.delegate = delegate
    }
    
    /**
     Call this method to initialize HyperTrack SDKs with your Account's PublishableKey
     in the application didFinishLaunchingWithOptions delegate method
     
     - Parameter publishableKey: Your account's publishable key
     */
    @objc public class func initialize(_ publishableKey: String) {
        Transmitter.sharedInstance.setPublishableKey(publishableKey:publishableKey)
        Transmitter.sharedInstance.initialize()
    }
    
    /**
     Call this method to get the publishableKey set on the HyperTrack SDK
     
     - Returns: The publishableKey configured on the SDK
     */
    @objc public class func getPublishableKey() -> String? {
        return Transmitter.sharedInstance.getPublishableKey()
    }
    
    /**
     Call this method to set UserId in HyperTrack SDK for the current user.
     
     - Parameter userId: The unique User Id generated by HyperTrack
     */
    @objc public class func setUserId(_ userId: String) {
        Transmitter.sharedInstance.setUserId(userId:userId)
    }
    
    /**
     Call this method to get the UserId set on the HyperTrack SDK
     
     - Returns: The userId configured on the SDK
     */
    @objc public class func getUserId() -> String? {
        return Transmitter.sharedInstance.getUserId()
    }
    
    /**
     This attribute refers to the current tracking status of the SDK.
     
     - Returns: A boolean representing if the SDK is currently tracking the User
     */
    @objc public class var isTracking:Bool {
        get {
            return Transmitter.sharedInstance.isTracking
        }
    }
    
    /**
     Call this method to fetch user's current location.
     
     - Parameter completionHandler: The completion handler which is called
     with the fetched location (CLLocation) on success or an error on failure
     */
    @objc public class func getCurrentLocation(completionHandler: @escaping (_ currentLocation: CLLocation?,
                                                                             _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.getCurrentLocation(completionHandler: completionHandler)
    }
    
    /**
     Call this method to get ETA from current location to a given 
     expected location. You can also specify a VehicleType to get vehicle
     specific ETA. Vehicle type can be one of "car", "van", "motorcycle",
     "three-wheeler", "bicycle", "walking".
     
     - Parameter expectedPlaceCoordinates: Coordinates for expectedPlace
     - Parameter vehicleType: String denoting the vehicle type for vehicle
     specific eta. If not specified default vehicle type is "car".
     - Parameter completionHandler: The completion handler which is called 
     with the fetched eta (in seconds) on success or an error on failure
     */
    @objc public class func getETA(expectedPlaceCoordinates: CLLocationCoordinate2D,
                                   vehicleType: String?,
                                   completionHandler: @escaping (_ eta: NSNumber?,
                                                                 _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.getETA(expectedPlaceCoordinates: expectedPlaceCoordinates,
                                          vehicleType: vehicleType,
                                          completionHandler: completionHandler)
    }
    
    /**
     Call this method to create a new user to track on HyperTrack.
     Also sets the newly created user as the user to track on the SDK.
     
     - Parameter name: The name of the user that will be created on HyperTrack
     */
    @objc public class func createUser(_ name: String) {
        Transmitter.sharedInstance.createUser(name, completionHandler:nil)
    }
    
    /**
     Call this method to create a new user to track on HyperTrack. This method also sets the newly created user as the user to track on the SDK.
     
     - Parameter name: The name of the user that will be created on HyperTrack
     - Parameter completionHandler: The completion handler which is called with the newly created user on success or an error on failure
     */
    @objc public class func createUser(_ name: String, completionHandler: @escaping (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.createUser(name, completionHandler:completionHandler)
    }
    
    /**
     Call this method to create a new user to track on HyperTrack. This method also sets the newly created user as the user to track on the SDK.
     
     - Parameter name: The name of the user that will be created on HyperTrack
     - Parameter phone: The phone number of the user that will be created on HyperTrack
     - Parameter photo: The photo of the user that will be created on HyperTrack
     - Parameter completionHandler: The completion handler which is called with the newly created user on success or an error on failure
     */
    @objc public class func createUser(_ name: String, _ phone: String, _ lookupID: String, _ photo: UIImage?, completionHandler: @escaping (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.createUser(name, phone, lookupID, photo, completionHandler)
    }
    
    /**
     Call this method to get or create a User on HyperTrack API Server for the current device
     with given lookup_id. Refer to the documentation on creating a user
     
     - Parameter userName : Name of the user
     - Parameter phone: E164 formatted phone number of the user
     - Parameter lookupId: A unique id that you can add to the user to search
     - Parameter completionHandler: The completion handler which is called with the newly created user on success or an error on failure
     */
    @objc public class func getOrCreateUser(_ name: String, _phone: String, _ lookupID: String, completionHandler: @escaping (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.createUser(name, _phone, lookupID, completionHandler)
    }
    
    /**
     Call this method to get or create a User on HyperTrack API Server for the current device
     with given lookup_id. Refer to the documentation on creating a user
     
     - Parameter userName : Name of the user
     - Parameter phone: E164 formatted phone number of the user
     - Parameter lookupId: A unique id that you can add to the user to search
     - Parameter photo: Image of the user
     - Parameter completionHandler: The completion handler which is called with the newly created user on success or an error on failure
     */
    @objc public class func getOrCreateUser(_ name: String, _ phone: String, _ lookupID: String, _ photo: UIImage?, completionHandler: @escaping (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.createUser(name, phone, lookupID, photo, completionHandler)
    }
    
    /**
     Call this method to start tracking on the SDK. This starts the location service if needed.
     
     - Requires: A userId (either through `setUserId` or `createUser`) and a publishable key(through `initialize`) to be set.
     */
    @objc public class func startTracking() {
        Transmitter.sharedInstance.startTracking(completionHandler: nil)
    }
    
    /**
     Call this method to start simulated tracking on the SDK. This mocks the location service internally.
     
     - Requires: A userId (either through `setUserId` or `createUser`) and a publishable key(through `initialize`) to be set.
     */
    @objc public class func startMockTracking() {
        Transmitter.sharedInstance.startMockTracking(completionHandler: nil)
    }
    
    /**
     Call this method to start tracking on the SDK. This starts the location service if needed.
     
     - Parameter completionHandler: The completion handler which is called with an error if there is an error starting
     - Requires: A userId (either through `setUserId` or `createUser`) and a publishable key(through `initialize`) to be set.
     */
    @objc public class func startTracking(completionHandler: @escaping (_ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.startTracking(completionHandler: completionHandler)
    }
    
    /**
     Call this method to create and assign an Action to the current user.
     
     - Parameter actionParams: Pass instance of HyperTrackActionParams
     - Parameter callback: Pass instance of HyperTrack callback as parameter
     */
    @objc public class func createAndAssignAction(_ actionParams:HyperTrackActionParams, _ completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.createAndAssignAction(actionParams, completionHandler)
    }
    
    /**
     Call this method to assign actions to the current user.
     
     - Parameter actionIds: Pass array of ActionIds casted as String
     - Parameter callback: Pass instance of HyperTrack callback as parameter
     */
    @objc public class func assignActions(actionIds:[String], _ completionHandler: @escaping (_ action: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.assignActions(actionIds, completionHandler)
    }
    
    /**
     Call this method to get action model for a given actionId
     
     - Parameter actionId: Pass the action's unique id generated on HyperTrack API Server
     - Parameter completionHandler: Pass instance of HyperTrack callback as parameter
     */
    @objc public class func getAction(_ actionId: String, completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.getAction(actionId, completionHandler)
    }
    
    /**
     Call this method to get action model for a given shortCode
     
     - Parameter shortCode: Pass the short code came from deeplink
     - Parameter completionHandler: Pass instance of HyperTrack callback as parameter
     */
    @objc public class func getActionsFromShortCode(_ shortCode: String, completionHandler: @escaping (_ action: [HyperTrackAction]?, _ error: HyperTrackError?) -> Void) {
        NSLog("getActionFromShortCode")
        Transmitter.sharedInstance.getActionFromShortCode(shortCode, completionHandler)
    }
    
    /**
     Call this method to track an Action on MapView embedded in your screen
     
     - Parameter actionId:  Pass the ActionId to be tracked on the mapView
     - Parameter completionHandler:  Pass instance of completion block as parameter
     */
    @objc public class func trackActionFor(actionID: String,
                                           completionHandler: ((_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void)? = nil) {
        HTMap.sharedInstance.trackActionFor(actionID: actionID, completionHandler: completionHandler)
    }
    
    /**
     Call this method to track an Action on MapView embedded in your screen
     
     - Parameter shortCode: Pass the action short code to be tracked on the mapView
     - Parameter completionHandler: Pass instance of completion block as parameter
     */
    @objc public class func trackActionFor(shortCode: String,
                                           completionHandler: ((_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void)? = nil) {
        HTMap.sharedInstance.trackActionFor(shortCode: shortCode, completionHandler: completionHandler)
    }
    
    /**
     Call this method to track an Action on MapView embedded in your screen
     
     - Parameter shortCode: Pass the action lookupId to be tracked on the mapView
     - Parameter completionHandler: Pass instance of completion block as parameter
     */
    @objc public class func trackActionFor(lookUpId: String,
                                           completionHandler: ((_ actions: [HyperTrackAction]?, _ error: HyperTrackError?) -> Void)? = nil) {
        HTMap.sharedInstance.trackActionFor(lookUpId: lookUpId, completionHandler: completionHandler)
    }
    
    /**
     Call this method to remove actions from the current set of tracked actions
     
     - Parameter actionIds: Array of action ids that need to be removed
     */
    @objc public class func removeActions(_ actionIds: [String]? = nil) {
        HTMap.sharedInstance.removeActions(actionIds)
    }
    
    /**
     Call this method to complete an action from the SDK with an actionId. Completes the provided actionId on HyperTrack.
     
     - Parameter actionId: The actionId to complete
     */
    @objc public class func completeAction(_ actionId: String) {
        Transmitter.sharedInstance.completeAction(actionId: actionId)
    }
    
    /**
     Call this method to cancel pending actions for the user.
     
     - Parameter completionHandler: The completion handler which is called with success or error
     */
    @objc public class func cancelPendingActions(completionHandler: @escaping (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.cancelPendingActions(completionHandler: completionHandler)
    }
    
    /**
     Call this method to stop tracking on the SDK and stop all running services.
     */
    @objc public class func stopTracking() {
        Transmitter.sharedInstance.stopTracking(completionHandler: nil)
    }
    
    /**
     Call this method to stop tracking on the SDK and stop all running services.
     
     - Parameter completionHandler: The completion handler which is called with an error if there is an error stopping
     */
    @objc public class func stopTracking(completionHandler: @escaping (_ error: HyperTrackError?) -> Void) {
        Transmitter.sharedInstance.stopTracking(completionHandler: completionHandler)
    }
    
    /**
     Call this method to stop simulated tracking on the SDK and stop all mock services.
     */
    @objc public class func stopMockTracking() {
        Transmitter.sharedInstance.stopMockTracking()
    }
    
    /**
     Returns an instance of the HyperTrack Map which can be used to track actions on.
     
     - Returns: HyperTrack map object
     */
    @objc public class func map() -> HTMap {
        return HTMap.sharedInstance
    }
    
    /**
     Call this method to get Location Authorization status. This can be one of:
    
     - notDetermined 
     (User has not yet made a choice with regards to this application)
     
     - restricted
     (This application is not authorized to use location services.)
     
     - denied
     (User has explicitly denied authorization for this application, or
     location services are disabled in Settings.)
     
     - authorizedAlways
     (User has granted authorization to use their location at any time,
     including monitoring for regions, visits, or significant location changes.)
     
     - authorizedWhenInUse
     (User has granted authorization to use their location only when your app
     is visible to them.)
     */
    @objc public class func locationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    // Utility methods
    /**
     Call this method to request the location when in use permission.
     */
    @objc public class func requestWhenInUseAuthorization() {
        Transmitter.sharedInstance.requestWhenInUseAuthorization()
    }
    
    /**
     Call this method to request the location always permission.
     */
    @objc public class func requestAlwaysAuthorization() {
        Transmitter.sharedInstance.requestAlwaysAuthorization()
    }
    
    /**
     Call this method to request the location always permission.
     */
    @objc public class func requestAlwaysAuthorization(completionHandler: @escaping (_ isAuthorized: Bool) -> Void) {
        Transmitter.sharedInstance.requestAlwaysAuthorization(completionHandler: completionHandler)
    }
    
    /**
     Call this method to check Motion Activity Authorization status.
     
     - Parameter completionHandler: The completion handler which is called with a 
     Bool indicating whether motion activity is authorized or not.
     */
    @objc public class func motionAuthorizationStatus(completionHandler: @escaping (_ isAuthorized: Bool) -> Void) {
        Transmitter.sharedInstance.motionAuthorizationStatus(completionHandler)
    }
    
    /**
     Call this method to check wether the device support activity estimation .
     
     Bool indicating whether motion activity is available or not.
     */
    
    @objc public class func canAskMotionPermissions()-> Bool{
        return CMMotionActivityManager.isActivityAvailable()
    }
    
    /**
     Call this method to request the motion permission.
     */
    @objc public class func requestMotionAuthorization() {
        Transmitter.sharedInstance.requestMotionAuthorization()
    }
    
    /**
     Call this method to check if Location Services are enabled or not.
     */
    @objc public class func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /**
     Call this method to request the motion permission.
     */
    @objc public class func requestLocationServices() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    HTLogger.shared.info("Location Services settings opened for user to enable it.")
                })
            } else {
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    /**
     Call this method to register for remote (silent) notifications inside
     application(_:didFinishLaunchingWithOptions:launchOptions:)
     */
    @objc public class func registerForNotifications() {
        PushNotificationService.registerForNotifications()
    }
    
    /**
     Call this method to handle successful remote notification registration
     inside application(_:didRegisterForRemoteNotificationsWithDeviceToken:)
     
     - Parameter deviceToken: The device token passed to the didRegisterForRemoteNotificationsWithDeviceToken application method
     */
    @objc public class func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {
        PushNotificationService.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }
    
    /**
     Call this method to handle unsuccessful remote notification registration
     inside application(_:didFailToRegisterForRemoteNotificationsWithError:)
     */
    @objc public class func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
        PushNotificationService.didFailToRegisterForRemoteNotificationsWithError(error: error)
    }
    
    /**
     Call this method to handle receiving a silent (remote) notification
     inside application(_:didReceiveRemoteNotification:)
     */
    @objc public class func didReceiveRemoteNotification(userInfo: [AnyHashable:Any]) {
        // Read notification data
        PushNotificationService.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    /**
     Call this method to check if notification is a HyperTrack notification
     
     - Parameter userInfo: The user info of the received notification
     - Returns: Boolean denoting whether user info belongs to a HyperTrack notification
     */
    @objc public class func isHyperTrackNotification(userInfo: [AnyHashable:Any]) -> Bool {
        return PushNotificationService.isHyperTrackNotification(userInfo: userInfo)
    }
    
    /**
     Call this method to get the current placeline activity of the user.
     */
    @objc public class func getPlaceline(date: Date? = nil, completionHandler: @escaping (_ placeline: HyperTrackPlaceline?, _ error: HyperTrackError?) -> Void) {
        return Transmitter.sharedInstance.getPlacelineActivity(date: date, completionHandler: completionHandler)
    }
}

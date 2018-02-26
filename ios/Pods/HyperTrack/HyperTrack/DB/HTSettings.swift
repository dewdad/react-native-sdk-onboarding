//
//  HTUserPreferences.swift
//  HyperTrack
//
//  Created by Tapan Pandita on 23/02/17.
//  Copyright © 2017 HyperTrack, Inc. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Settings {
   private static let publishableKeyString = "HyperTrackPublishableKey"

   private static let mockTrackingString = "HyperTrackIsMockTracking"

   private static let lastKnownLocationString = "HyperTrackLastKnownLocation"
   private static let minimumDurationString = "HyperTrackMinimumDuration"
   private static let minimumDisplacementString = "HyperTrackMinimumDisplacement"
   private static let batchDurationString = "HyperTrackBatchDuration"

   private static let mockCoordinatesString = "HyperTrackMockCoordinates"
   private static let savedPlacesString = "HyperTrackSavedPlaces"

   private static let trackingString = "HyperTrackIsTracking"
   private static let htSessionId = "HyperTrackSessionId"
   private static let htDeviceId = "HyperTrackDeviceId"
   private static let htTrackingStartedDate = "HyperTrackTrackingStartedDate"
   private static let lastActiveTimeOfSDKKeyString = "lastActiveTimeOfSDK"

    static func getBundle() -> Bundle? {
        let bundleRoot = Bundle(for: HyperTrack.self)
        
        print(bundleRoot.bundlePath)
        return Bundle(path: "\(bundleRoot.bundlePath)/HyperTrack.bundle")
    }

    static var sdkVersion: String {
        get {
            if let bundle = Settings.getBundle() {
                let dictionary = bundle.infoDictionary!
                if let version = dictionary["CFBundleShortVersionString"] as? String {
                    return version
                }
            }
            return ""
        }
    }

    static var sessionId: String {
        get {
            return HypertrackUserDefaults.standard.string(forKey: htSessionId) ?? ""
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: htSessionId)
            HypertrackUserDefaults.standard.synchronize()
        }
    }
    
    
    static var deviceId: String {
        get {
            return HypertrackUserDefaults.standard.string(forKey: htDeviceId) ?? ""
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: htDeviceId)
            HypertrackUserDefaults.standard.synchronize()
        }
    }
    
    
    static var lastActiveTimeOfSDK: Date? {
        get {
            return HypertrackUserDefaults.standard.object(forKey: lastActiveTimeOfSDKKeyString) as? Date
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: lastActiveTimeOfSDKKeyString)
            HypertrackUserDefaults.standard.synchronize()
        }
    }
    

    static func setPublishableKey(publishableKey: String) {
        HypertrackUserDefaults.standard.set(publishableKey, forKey: publishableKeyString)
        HypertrackUserDefaults.standard.synchronize()
    }

    static func getPublishableKey() -> String? {
        return HypertrackUserDefaults.standard.string(forKey: publishableKeyString)
    }

    static func setTracking(isTracking: Bool) {
        HypertrackUserDefaults.standard.set(isTracking, forKey: trackingString)
        HypertrackUserDefaults.standard.synchronize()
    }

    static func getTracking() -> Bool {
        return HypertrackUserDefaults.standard.bool(forKey: trackingString)
    }

    static func setMockTracking(isTracking: Bool) {
        HypertrackUserDefaults.standard.set(isTracking, forKey: mockTrackingString)
        HypertrackUserDefaults.standard.synchronize()
    }

    static func getMockTracking() -> Bool {
        return HypertrackUserDefaults.standard.bool(forKey: mockTrackingString)
    }

    static func setLastKnownLocation(location: HyperTrackLocation) {
        let locationJSON = location.toJson()
        HypertrackUserDefaults.standard.set(locationJSON, forKey: lastKnownLocationString)
        HypertrackUserDefaults.standard.synchronize()
    }

    static func getLastKnownLocation() -> HyperTrackLocation? {
        guard let locationString = HypertrackUserDefaults.standard.string(forKey: lastKnownLocationString) else { return nil}
        let htLocation = HyperTrackLocation.fromJson(text: locationString)
        return htLocation
    }
    
    static func setMockCoordinates(coordinates: [TimedCoordinates]) {
        HypertrackUserDefaults.standard.set(timedCoordinatesToStringArray(coordinates: coordinates), forKey: mockCoordinatesString)
    }

    static func getMockCoordinates() -> [TimedCoordinates]? {
        if let object = HypertrackUserDefaults.standard.string(forKey: mockCoordinatesString) {
            return timedCoordinatesFromStringArray(coordinatesString: object)
        }
        return nil
    }

    static func addPlaceToSavedPlaces(place: HyperTrackPlace) {
        var savedPlaces = getAllSavedPlaces()
        if savedPlaces != nil {
            if(!HTGenericUtils.checkIfContains(places: savedPlaces!, inputPlace: place)) {
                savedPlaces?.append(place)
            } else {
                var frequency = HypertrackUserDefaults.standard.integer(forKey: place.getIdentifier())
                frequency +=  1
                HypertrackUserDefaults.standard.set(frequency, forKey: place.getIdentifier())
                HypertrackUserDefaults.standard.synchronize()
            }
        } else {
            savedPlaces = [place]
        }

        var savedPlacesDictArray = [[String: Any]]()
        for htPlace in savedPlaces! {
            let htPlaceDict = htPlace.toDict()
            savedPlacesDictArray.append(htPlaceDict)

        }

        var jsonDict = [String: Any]()
        jsonDict["results"] = savedPlacesDictArray

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            HypertrackUserDefaults.standard.set(jsonData, forKey: savedPlacesString)
            HypertrackUserDefaults.standard.synchronize()
        } catch {
            DDLogError("Error in getting actions from json: " + error.localizedDescription)
        }
    }

    static func getAllSavedPlaces() -> [HyperTrackPlace]? {
        if let jsonData = HypertrackUserDefaults.standard.data(forKey: savedPlacesString) {
            var htPlaces = HyperTrackPlace.multiPlacesFromJson(data: jsonData)
            htPlaces = htPlaces?.reversed()
            var placeToFrequencyMap = [HyperTrackPlace: Int]()
            for place in htPlaces! {
                let frequency = HypertrackUserDefaults.standard.integer(forKey: place.getIdentifier())
                placeToFrequencyMap[place] = frequency
            }

            let sortedKeys = Array(placeToFrequencyMap.keys).sorted(by: {placeToFrequencyMap[$1]! < placeToFrequencyMap[$0]!})
            return sortedKeys
        }
        return []
    }
    
    
    static var trackingStartedAt: Date? {
        get {
            return HypertrackUserDefaults.standard.object(forKey: htTrackingStartedDate) as? Date
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: htTrackingStartedDate)
            HypertrackUserDefaults.standard.synchronize()
        }
    }
    
    static func deleteAllValues(){
        HypertrackUserDefaults.standard.deleteAllValues()
    }
    
    static func deleteRegisteredToken(){
    
    }

}

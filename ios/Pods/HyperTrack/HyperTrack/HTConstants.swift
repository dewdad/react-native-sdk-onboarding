//
//  HTConstants.swift
//  Pods
//
//  Created by Ravi Jain on 04/06/17.
//
//

import UIKit

public struct HTConstants {
  
    enum UseCases: Int {
        case singleUserSingleAction = 0
        case singleUserMultipleAction = 1
        case multipleUserMultipleAction = 2
        case multipleUserMultipleActionSamePlace = 3
    }

   static let HTLocationPermissionChangeNotification = "LocationPermissionChangeNotification"
   static let HTUserIdCreatedNotification = "UserIdCreatedNotification"
   static let HTTrackingStartedForLookUpId = "HTTrackingStartedForLookUpId"
   static let HTTrackingStopedForAction = "HTTrackingStoppedForAction"
   static let HTTrackingStopedForLookUpId = "HTTrackingStoppedForLookUpId"
   public static let HTLocationChangeNotification = "HTLocationChangeNotification"
   static let HTLocationHeadingChangeNotification = "HTLocationHeadingChangeNotification"
   static let HTMonitoredRegionEntered = "HTMonitoredRegionEntered"
   static let HTMonitoredRegionExited = "HTMonitoredRegionExited"
   static let HTSDKControlsRefreshedNotification = "HTSDKControlsRefreshedNotification"
   static let HTPowerStateChangedNotification = "HTPowerStateChangedNotification"
   static let HTNetworkStateChangedNotification = "HTNetworkStateChangedNotification"
   static let HTTrackingStartedNotification = "HTTrackingStartedNotification"

}

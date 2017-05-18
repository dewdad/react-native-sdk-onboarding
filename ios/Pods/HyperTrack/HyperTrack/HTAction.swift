//
//  HTAction.swift
//  HyperTrack
//
//  Created by Tapan Pandita on 10/03/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import Foundation


@objc public class HyperTrackAction:NSObject {

  public let id: String?
  public let user: HyperTrackUser?
  public let type: String?
  public let expectedPlace: HyperTrackPlace?
  public let expectedAt: Date?
  public let completedPlace: HyperTrackPlace?
  public let completedAt: Date?
  public let assignedAt: Date?
  public let startedPlace: HyperTrackPlace?
  public let startedAt: Date?
  public let status: String?
  public let eta: Date?
  public let initialEta: Date?
  public let trackingUrl: String?
  public let lookupId: String?
  public let display: [String:Any]?
  public let encodedPolyline: String?
  public let timeAwarePolyline: String?

  init(id: String?,
       user: HyperTrackUser?,
       type: String?,
       expectedPlace: HyperTrackPlace?,
       expectedAt: Date?,
       completedPlace: HyperTrackPlace?,
       completedAt: Date?,
       assignedAt: Date?,
       startedPlace: HyperTrackPlace?,
       startedAt: Date?,
       status: String?,
       eta: Date?,
       initialEta: Date?,
       trackingUrl: String?,
       lookupId: String?,
       display: [String:Any]?,
       encodedPolyline: String?,
       timeAwarePolyline: String?
    ) {
    self.id = id
    self.user = user
    self.type = type
    self.expectedPlace = expectedPlace
    self.expectedAt = expectedAt
    self.completedPlace = completedPlace
    self.completedAt = completedAt
    self.assignedAt = assignedAt
    self.startedPlace = startedPlace
    self.startedAt = startedAt
    self.status = status
    self.eta = eta
    self.initialEta = initialEta
    self.trackingUrl = trackingUrl
    self.lookupId = lookupId
    self.display = display
    self.encodedPolyline = encodedPolyline
    self.timeAwarePolyline = timeAwarePolyline
  }

  public func toDict() -> [String:Any] {
    let dict = [
      "id": self.id as Any,
      "user": self.user?.toDict() as Any,
      "type": self.type as Any,
      "expected_place": self.expectedPlace?.toDict() as Any,
      "expected_at": self.expectedAt?.iso8601 as Any,
      "completed_place": self.completedPlace?.toDict() as Any,
      "completed_at": self.completedAt?.iso8601 as Any,
      "assigned_at": self.assignedAt?.iso8601 as Any,
      "started_place": self.startedPlace?.toDict() as Any,
      "stated_at": self.startedAt?.iso8601 as Any,
      "status": self.status as Any,
      "eta": self.eta?.iso8601 as Any,
      "initial_eta": self.initialEta?.iso8601 as Any,
      "tracking_url": self.trackingUrl as Any,
      "lookup_id": self.lookupId as Any,
      "display": self.display as Any,
      "encoded_polyline": self.encodedPolyline as Any,
      "time_aware_polyline": self.timeAwarePolyline as Any
      ] as [String:Any]
    return dict
  }

  public func toJson() -> String? {
    let dict = self.toDict()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dict)
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
      return jsonString
    } catch {
      debugPrint("Error serializing object to JSON: %@", error.localizedDescription)
      return nil
    }
  }

  public static func fromDict(dict:[String:Any]) -> HyperTrackAction? {

    let action = HyperTrackAction(
      id: dict["id"] as? String,
      user: dict["user"] as? HyperTrackUser,
      type: dict["type"] as? String,
      expectedPlace: HyperTrackPlace.fromDict(dict: dict["expected_place"] as? [String:Any]),
      expectedAt: (dict["expected_at"] as? String)?.dateFromISO8601,
      completedPlace: HyperTrackPlace.fromDict(dict: dict["completed_place"] as? [String:Any]),
      completedAt: (dict["completed_at"] as? String)?.dateFromISO8601,
      assignedAt: (dict["assigned_at"] as? String)?.dateFromISO8601,
      startedPlace: HyperTrackPlace.fromDict(dict: dict["started_place"] as? [String:Any]),
      startedAt: (dict["started_at"] as? String)?.dateFromISO8601,
      status: dict["status"] as? String,
      eta: (dict["eta"] as? String)?.dateFromISO8601,
      initialEta: (dict["initial_eta"] as? String)?.dateFromISO8601,
      trackingUrl: dict["tracking_url"] as? String,
      lookupId: dict["lookup_id"] as? String,
      display: dict["display"] as? [String: Any],
      encodedPolyline: dict["encoded_polyline"] as? String,
      timeAwarePolyline: dict["time_aware_polyline"] as? String
    )

    return action
  }

  public static func fromJson(data:Data?) -> HyperTrackAction? {
    do {
      let jsonDict = try JSONSerialization.jsonObject(with: data!, options: [])

      guard let dict = jsonDict as? [String : Any] else {
        return nil
      }

      return self.fromDict(dict:dict)
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }

}

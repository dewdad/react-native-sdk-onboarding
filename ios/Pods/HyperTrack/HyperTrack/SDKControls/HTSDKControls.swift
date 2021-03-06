//
//  HTSDKControls.swift
//  HyperTrack
//
//  Created by Tapan Pandita on 09/03/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import Foundation
import CocoaLumberjack


public enum HTSDKControlsRunCommand: String {
    case goActive = "GO_ACTIVE"
    case goOffline = "GO_OFFLINE"
    case goOnline = "GO_ONLINE"
}

class HyperTrackSDKControls {
    public static let defaultBatchDuration = 30.0 * 60.0 // seconds
    public static let defaultMinimumDuration = 5.0 // seconds
    public static let defaultMinimumDisplacement = 50.0 // meters
    public static let defaultTTL = 24.0 * 60.0 * 60.0
    public static let minimumTTL = 2.0 * 60.0

    public let userId: String?
    public let runCommand: HTSDKControlsRunCommand?
    public var ttl: Double?
    public let minimumDuration: Double?
    public let minimumDisplacement: Double?
    public let batchDuration: Double?
    public var isFromServer = false
    public let recordedAt = Date()
    public var isForced = false
    
    public init(userId: String?,
                runCommand: String?,
                ttl: Double?,
                minimumDuration: Double?,
                minimumDisplacement: Double?,
                batchDuration: Double?) {
        self.userId = userId
        self.runCommand = HTSDKControlsRunCommand.init(rawValue: runCommand ?? "GO_ACTIVE")
        self.ttl = ttl
        self.minimumDuration = minimumDuration
        self.minimumDisplacement = minimumDisplacement
        self.batchDuration = batchDuration
    }
    
    public func getTransmissionControls() -> HTTransmissionControls {
        return HTTransmissionControls.init(ttl: self.ttl ?? HyperTrackSDKControls.defaultTTL, batchDuration: self.batchDuration ?? HyperTrackSDKControls.defaultBatchDuration, batchSize: 50)
    }
    
    public static func getDefaultControls() -> HyperTrackSDKControls {
        let controls = HyperTrackSDKControls.init(userId: HTUserService.sharedInstance.userId, runCommand: "GO_ONLINE", ttl: defaultTTL, minimumDuration: defaultMinimumDuration, minimumDisplacement: defaultMinimumDisplacement, batchDuration: defaultBatchDuration)
        return controls
    }
    
    public static func fromDict(dict: [String: Any]?) -> HyperTrackSDKControls? {
        guard let dict = dict else {
            return nil
        }

        guard let userId = dict["user_id"] as? String,
            let runCommand = dict["run_command"] as? String?,
            let minimumDuration = dict["minimum_duration"] as? Double?,
            let minimumDisplacement = dict["minimum_displacement"] as? Double?,
            let batchDuration = dict["batch_duration"] as? Double?,
            let ttl = dict["ttl"] as? Double? else {
                return nil
        }

        let controls = HyperTrackSDKControls(
            userId: userId,
            runCommand: runCommand,
            ttl: ttl,
            minimumDuration: minimumDuration,
            minimumDisplacement: minimumDisplacement,
            batchDuration: batchDuration
        )

        return controls
    }

    internal func toDict() -> [String: Any] {
        let dict = [
            "user_id": self.userId as Any,
            "run_command": self.runCommand?.rawValue as Any,
            "minimum_duration": self.minimumDuration as Any,
            "minimum_displacement": self.minimumDisplacement as Any,
            "batch_duration": self.batchDuration as Any,
            "ttl": self.ttl as Any
            ] as [String: Any]
        return dict
    }

    public static func fromJson(data: Data?) -> HyperTrackSDKControls? {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data!, options: [])

            guard let dict = jsonDict as? [String: Any] else {
                return nil
            }

            return self.fromDict(dict: dict)
        } catch {
            DDLogError("Error in getting sdk controls from json: " + error.localizedDescription)
            return nil
        }
    }
}

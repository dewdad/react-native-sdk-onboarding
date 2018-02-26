//
//  HTUserService.swift
//  HyperTrack
//
//  Created by Ravi Jain on 8/5/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import UIKit
import CocoaLumberjack

typealias HTUserResultHandler = (_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void

class HTUserService: NSObject {

    static let sharedInstance = HTUserService()

    private let userIdString = "HyperTrackUserId"
    private let lookupIdString = "HyperTrackLookupId"
    private let savedUser = "HyperTrackSavedUser"

    let requestManager: RequestManager

    override init() {
        self.requestManager = RequestManager()
    }
    
    
    var userId: String? {
        get {
            return HypertrackUserDefaults.standard.string(forKey: userIdString)
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: userIdString)
            HypertrackUserDefaults.standard.synchronize()
            HypertrackService.sharedInstance.pushNotificationService.registerDeviceToken()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: HTConstants.HTUserIdCreatedNotification),
                    object: nil,
                    userInfo: nil)
        }
    }
    
    var lookUpId: String {
        get {
            return HypertrackUserDefaults.standard.string(forKey: lookupIdString) ?? ""
        }
        
        set {
            HypertrackUserDefaults.standard.set(newValue, forKey: lookupIdString)
            HypertrackUserDefaults.standard.synchronize()
        }
    }

    func  createUser(_ name: String, completionHandler: HTUserResultHandler?) {
        self.requestManager.createUser(["name": name]) { user, error in

            if  let user = user {
                self.userId = user.id
                self.saveUser(user: user)
            }
            else if error != nil {
                DDLogError("Error creating user: \(String(describing: error?.type.rawValue))")
            }
            else{
                DDLogError("Error creating user: user is null")
            }
          
            if completionHandler != nil {
                completionHandler!(user, error)
            }
        }
    }

    func createUser(_ name: String, _ phone: String, _ lookupID: String, _ photo: UIImage?, _ completionHandler: @escaping HTUserResultHandler) {
        var requestBody = ["name": name, "phone": phone, "lookup_id": lookupID]

        if let photo = photo {
            // Convert image to base64 before upload
            if let imageData = UIImagePNGRepresentation(photo) {
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                requestBody["photo"] = strBase64
            }
        }

        self.requestManager.createUser(requestBody) { user, error in
            if  let user = user {
                self.userId = user.id
                self.saveUser(user: user)
            } else if error != nil {
                DDLogError("Error creating user: \(String(describing: error?.type.rawValue))")
            }
            else{
                DDLogError("Error creating user: user is null")
            }

            completionHandler(user, error)
        }
    }

    func createUser(_ name: String, _ phone: String, _ lookupID: String, _ completionHandler: @escaping HTUserResultHandler) {

        self.requestManager.createUser(["name": name, "phone": phone, "lookup_id": lookupID]) { user, error in
            if  let user = user {
                self.userId = user.id
                self.saveUser(user: user)
                self.lookUpId = lookupID
            } else if error != nil {
                DDLogError("Error creating user: \(String(describing: error?.type.rawValue))")
            }
            else{
                DDLogError("Error creating user: user is null")
            }

            completionHandler(user, error)
        }
    }

    func updateUser(_ name: String, _ phone: String? = nil, _ lookupID: String? = nil, _ photo: UIImage? = nil, _ completionHandler: @escaping HTUserResultHandler) {

        var requestBody = ["name": name]
        if phone != nil {
            requestBody["phone"] = phone
        }

        if lookupID != nil {
            requestBody["lookup_id"] = lookupID
        }

        if let photo = photo {
            // Convert image to base64 before upload
            if let imageData = UIImagePNGRepresentation(photo) {
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                requestBody["photo"] = strBase64
            }
        }

        self.requestManager.updateUser(requestBody) { user, error in
            if  let user = user {
                self.userId = user.id
                self.saveUser(user: user)
            } else if error != nil {
                DDLogError("Error creating user: \(String(describing: error?.type.rawValue))")
            }
            else{
                DDLogError("Error creating user: user is null")
            }

            completionHandler(user, error)
        }
    }
    
    func saveUser(user: HyperTrackUser) {
        let jsonData = user.toJson()
        HypertrackUserDefaults.standard.set(jsonData, forKey: savedUser)
        HypertrackUserDefaults.standard.synchronize()
    }
    
    func getUser() -> HyperTrackUser? {
        if let jsonData = HypertrackUserDefaults.standard.string(forKey: savedUser) {
            return HyperTrackUser.fromJson(text: jsonData)
        }
        return nil
    }
    
    func getPlacelineActivity(date: Date? = nil, userID: String? = nil, completionHandler: @escaping (_ placeline: HyperTrackPlaceline?, _ error: HyperTrackError?) -> Void) {
        // TODO: this method should not be in Transmitter, but needs access to request manager
        var user = userID
        if user == nil {
            user = HTUserService.sharedInstance.userId
        }
        
        guard let userId = user else {
            completionHandler(nil, HyperTrackError(HyperTrackErrorType.userIdError))
            return
        }
        
        requestManager.getUserPlaceline(date: date, userId: userId) { (placeline, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(placeline, nil)
        }
    }
    
    public func isCurrentUser(userId: String?) -> Bool {
        if let userId = userId {
            if let currentUserId = HTUserService.sharedInstance.userId {
                if currentUserId == userId {
                    return true
                }
            }
        }
        return false
    }

}

//
 //  HTRequestManager.swift
 //  HyperTrack
 //
 //  Created by Tapan Pandita on 24/02/17.
 //  Copyright © 2017 HyperTrack, Inc. All rights reserved.
 //

 import Foundation
 import Alamofire
 import MapKit
 import Gzip
 import CocoaLumberjack


 class RequestManager {
    
    func getPublishableKey() -> (String?, HyperTrackError?) {
        if let publishableKey = Settings.getPublishableKey() {
            if publishableKey != ""{
                return (publishableKey, nil)
            }
        }

        let error = HyperTrackError(HyperTrackErrorType.publishableKeyError)
        return (nil, error)
    }
    
    func getHyperTrackError(response: (DataResponse<Any>)) -> HyperTrackError{
            if response.response?.statusCode == 403 {
                // handle auth error
                let htError = HyperTrackError(HyperTrackErrorType.authorizationFailedError)
                DDLogError("Error while \(response.request?.url?.description ?? "") : \(htError.errorMessage)")
                return htError
            } else {
                let htError = HyperTrackError(HyperTrackErrorType.serverError, responseData: response.data)
                DDLogError("Error while \(response.request?.url?.description ?? "") : \(htError.errorMessage)")
                return htError
            }
    }

    func getAction(_ actionId: String, completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {
        let urlPath = "actions/\(actionId)/detailed/"

        if let error = self.getPublishableKey().1 {
            DDLogError("getAction fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let action = HyperTrackAction.fromJson(data: response.data)
                completionHandler(action, nil)
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func getActionFromShortCode(_ shortCode: String, completionHandler: @escaping (_ actions: [HyperTrackAction]?, _ error: HyperTrackError?) -> Void) {

        let urlPath = "actions/?short_code=\(shortCode)"
        if let error = self.getPublishableKey().1 {
            DDLogError("getActionFromShortCode fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let actions = HyperTrackAction.multiActionsFromJSONData(data: response.data)
                completionHandler(actions, nil)
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func fetchDetailsForActions(_ actionIDs: [String], completionHandler: @escaping (_ users: [HTTrackedUser]?, _ error: HyperTrackError?) -> Void) {

        let actionsToTrack = actionIDs.joined(separator: ",")
        let urlPath = "actions/track/?id=\(actionsToTrack)"

        if let error = self.getPublishableKey().1 {
            DDLogError("fetchDetailsForActions fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let users = HTTrackedUser.usersFromJSONData(data: response.data)
                completionHandler(users, nil)

            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func fetchDetailsForActionsByShortCodes(_ shortCodes: [String],
                                            completionHandler: @escaping (_ users: [HTTrackedUser]?, _ error: HyperTrackError?) -> Void) {

        let actionsToTrack = shortCodes.joined(separator: ",")
        let urlPath = "actions/track/?short_code=\(actionsToTrack)"

        if let error = self.getPublishableKey().1 {
            DDLogError("fetchDetailsForActionsByShortCodes fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let users =  HTTrackedUser.usersFromJSONData(data: response.data)
                completionHandler(users, nil)

            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func fetchDetailsForActionsByLookUpId(_ lookUpId: String, completionHandler: @escaping (_ users: [HTTrackedUser]?, _ error: HyperTrackError?) -> Void) {

        let urlPath = "actions/track/?lookup_id=\(lookUpId)"

        if let error = self.getPublishableKey().1 {
            DDLogError("fetchDetailsForActionsByLookUpId fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let users =  HTTrackedUser.usersFromJSONData(data: response.data)
                completionHandler(users, nil)

            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func fetchDetailsForActionsByCollectionId(_ collectionId: String, completionHandler: @escaping (_ users: [HTTrackedUser]?, _ error: HyperTrackError?) -> Void) {

        let urlPath = "actions/track/?collection_id=\(collectionId)"

        if let error = self.getPublishableKey().1 {
            DDLogError("fetchDetailsForActionsByCollectionId fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let users =  HTTrackedUser.usersFromJSONData(data: response.data)
                completionHandler(users, nil)

            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func fetchUserDetailsForActions(_ actionIDs: [String], completionHandler: @escaping (_ actions: [HTTrackedUser]?, _ error: HyperTrackError?) -> Void) {

        if let error = self.getPublishableKey().1 {
            DDLogError("fetchUserDetailsForActions fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        let actionsToTrack = actionIDs.joined(separator: ",")
        let urlPath = "actions/track/?id=\(actionsToTrack)"
        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let users =  HTTrackedUser.usersFromJSONData(data: response.data)
                completionHandler(users, nil)
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func createAndAssignAction(_ action: [String: Any], completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {

        if let error = self.getPublishableKey().1 {
            DDLogError("createAndAssignAction fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .post, urlPath: "actions/", jsonParams: action).makeRequest { response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError)
                        completionHandler(nil, htError)
                        return
                    }

                    let action = HyperTrackAction.fromDict(dict: jsonDict)
                    completionHandler(action, nil)
                } catch {
                    DDLogError("Error serializing action: \(error.localizedDescription)")
                }
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func assignActions(userId: String, _ params: [String: Any], completionHandler: @escaping (_ action: HyperTrackUser?,
        _ error: HyperTrackError?) -> Void) {

        if let error = self.getPublishableKey().1 {
            DDLogError("assignActions fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        let url = "users/" + userId + "/assign_actions/"
        HTNetworkRequest(method: .post, urlPath: url, jsonParams: params).makeRequest { response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError)
                        completionHandler(nil, htError)
                        return
                    }

                    let user = HyperTrackUser.fromDict(dict: jsonDict)
                    completionHandler(user, nil)
                } catch {
                    DDLogError("Error serializing user: \(error.localizedDescription)")
                }
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func patchActionInSynch(_ actionId: String, _ params: [String: Any], _ completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {

        if let error = self.getPublishableKey().1 {
            DDLogError("patchActionInSynch fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        let url = "actions/" + actionId  + "/"
        HTNetworkRequest(method: .patch, urlPath: url, jsonParams: params).makeRequest { response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError)
                        completionHandler(nil, htError)
                        return
                    }

                    let action = HyperTrackAction.fromDict(dict: jsonDict)
                    completionHandler(action, nil)
                } catch {
                    DDLogError("Error serializing action: \(error.localizedDescription)")
                }
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }

    }

    func completeActionInSynch(_ actionId: String, _ params: [String: Any], completionHandler: @escaping (_ action: HyperTrackAction?, _ error: HyperTrackError?) -> Void) {
        let url = "actions/" + actionId  + "/complete/"

        if let error = self.getPublishableKey().1 {
            DDLogError("completeActionInSynch fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        HTNetworkRequest(method: .post, urlPath: url, jsonParams: params).makeRequest { response in
            switch response.result {
            case .success:
                let action = HyperTrackAction.fromJson(data: response.data)
                completionHandler(action, nil)
            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func createUser(_ user: [String: Any], completionHandler: ((_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("createUser fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        HTNetworkRequest(method: .post, urlPath: "users/", jsonParams: user).makeRequest { response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError, responseData: response.data)
                        guard let completionHandler = completionHandler else { return }
                        completionHandler(nil, htError)
                        return
                    }

                    let user = HyperTrackUser.fromDict(dict: jsonDict)
                    guard let completionHandler = completionHandler else { return }
                    completionHandler(user, nil)
                } catch {
                    DDLogError("Error serializing user: \(error.localizedDescription)")
                }
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func updateUser(_ user: [String: Any], completionHandler: ((_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("updateUser fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        HTNetworkRequest(method: .patch, urlPath: "users/", jsonParams: user).makeRequest { response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError, responseData: response.data)
                        guard let completionHandler = completionHandler else { return }
                        completionHandler(nil, htError)
                        return
                    }

                    let user = HyperTrackUser.fromDict(dict: jsonDict)
                    guard let completionHandler = completionHandler else { return }
                    completionHandler(user, nil)
                } catch {
                    DDLogError("Error serializing user: \(error.localizedDescription)")
                }
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func getETA(currentLocationCoordinates: CLLocationCoordinate2D,
                expectedPlaceCoordinates: CLLocationCoordinate2D,
                vehicleType: String,
                completionHandler: @escaping (_ eta: NSNumber?, _ error: HyperTrackError?) -> Void) {

        if let error = self.getPublishableKey().1 {
            DDLogError("getETA fails as publishable Key is not set")
            completionHandler(nil, error)
            return
        }

        let currentLocationParam: String = String(currentLocationCoordinates.latitude)
            + "," + String(currentLocationCoordinates.longitude)
        let expectedPlaceParam: String = String(expectedPlaceCoordinates.latitude)
            + "," + String(expectedPlaceCoordinates.longitude)
        let url = "get_eta/?origin=" + currentLocationParam + "&destination=" +
            expectedPlaceParam + "&vehicle_type=" + vehicleType

        HTNetworkRequest(method: .get, urlPath: url, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                if let etaResponse = response.result.value as? [String: AnyObject],
                    let etaInSeconds = etaResponse["duration"] as? NSNumber,
                    etaInSeconds.doubleValue >= 0.0 {
                    completionHandler(etaInSeconds, nil)
                    return
                }

                let htError = HyperTrackError(HyperTrackErrorType.invalidETAError, responseData: response.data)
                DDLogError("Error while getETA: \(htError.errorMessage)")
                completionHandler(nil, htError)

            case .failure:
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func cancelActions(userId: String, completionHandler: ((_ user: HyperTrackUser?, _ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("getETA fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        HTNetworkRequest(method: .post, urlPath: "users/\(userId)/cancel_actions/", jsonParams: [:]).makeRequest {
            response in
            switch response.result {
            case .success:
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        let htError = HyperTrackError(HyperTrackErrorType.jsonError, responseData: response.data)
                        guard let completionHandler = completionHandler else { return }
                        completionHandler(nil, htError)
                        return
                    }

                    let user = HyperTrackUser.fromDict(dict: jsonDict)
                    guard let completionHandler = completionHandler else { return }
                    completionHandler(user, nil)
                } catch {
                    DDLogError("Error serializing user: \(error.localizedDescription)")
                }
            case .failure:
                if response.response?.statusCode == 403 {
                    // handle auth error
                    let htError = HyperTrackError(HyperTrackErrorType.authorizationFailedError, responseData: response.data)
                    DDLogError("Error while cancelActions: \(htError.errorMessage)")
                    guard let completionHandler = completionHandler else { return }
                    completionHandler(nil, htError)
                } else {
                    let htError = HyperTrackError(HyperTrackErrorType.serverError, responseData: response.data)
                    DDLogError("Error while cancelActions: \(htError.errorMessage)")
                    guard let completionHandler = completionHandler else { return }
                    completionHandler(nil, htError)}
            }
        }
    }

    func registerDeviceToken(userId: String, deviceId: String, registrationId: String, completionHandler: ((_ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("getETA fails as publishable Key is not set")
            completionHandler?(error)
            return
        }

        var json = [String: String]()
        json["user_id"] = userId
        json["device_id"] = deviceId
        json["registration_id"] = registrationId

        HTNetworkRequest(method: .post, urlPath: "apnsdevices/", jsonParams: json).makeRequest { response in
            switch response.result {
            case .success:
                guard let completionHandler = completionHandler else { return }
                completionHandler(nil)
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(htError)
            }
        }
    }

    func getSDKControls(userId: String, completionHandler: ((_ controls: HyperTrackSDKControls?, _ error: HyperTrackError?) -> Void)?) {
        let urlPath = "users/\(userId)/controls/"

        if let error = self.getPublishableKey().1 {
            DDLogError("getSDKControls fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [: ]).makeRequest { response in
            switch response.result {
            case .success:
                let controls = HyperTrackSDKControls.fromJson(data: response.data)
                guard let completionHandler = completionHandler else { return }
                completionHandler(controls, nil)
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)            }
        }
    }

    func getSimulatePolyline(originLatlng: String, destinationLatLong: String? = nil, completionHandler: ((_ polyline: String?, _ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("getSimulatePolyline fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        var urlPath = "simulate/?origin=\(originLatlng)"
        if destinationLatLong != nil {
            urlPath = "simulate/?origin=\(originLatlng)&destination=\(destinationLatLong ?? "")"

        }
        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                var polyline = ""
                if  let result = response.result.value as? [String: String] {
                    polyline = result["time_aware_polyline"]!
                }
                guard let completionHandler = completionHandler else { return }
                completionHandler(polyline, nil)

            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func findPlaces(searchText: String?, cordinate: CLLocationCoordinate2D?, completionHandler: ((_ places: [HyperTrackPlace]?, _ error: HyperTrackError?) -> Void)?) {

        if let error = self.getPublishableKey().1 {
            DDLogError("findPlaces fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        let escapedString = searchText?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var urlPath = "places/search/?q=" + escapedString!
        if cordinate != nil {
            urlPath +=  "&lat=" + (cordinate?.latitude.description)! + "&lon=" + (cordinate?.longitude.description)!
        }

        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let places  = HyperTrackPlace.multiPlacesFromJson(data: response.data)
                completionHandler!(places, nil)
                break

            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }

    }

    func createPlace(geoJson: HTGeoJSONLocation, completionHandler: ((_ place: HyperTrackPlace?, _ error: HyperTrackError?) -> Void)?) {
        let urlPath = "places/"
        var json = [String: String]()
        json["location"] = geoJson.toJson()

        if let error = self.getPublishableKey().1 {
            DDLogError("createPlace fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        HTNetworkRequest(method: .post, urlPath: urlPath, jsonParams: json).makeRequest { response in
            switch response.result {
            case .success:
                let places  = HyperTrackPlace.fromJson(text: String.init(data: response.data!, encoding: .utf8)!)
                completionHandler!(places, nil)

            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

    func getUserPlaceline(date: Date? = nil, userId: String, completionHandler: ((_ controls: HyperTrackPlaceline?, _ error: HyperTrackError?) -> Void)?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.string(from: Date())

        if let date = date {
            dateString = formatter.string(from: date)
        }

        if let error = self.getPublishableKey().1 {
            DDLogError("getUserPlaceline fails as publishable Key is not set")
            completionHandler?(nil, error)
            return
        }

        let urlPath = "users/\(userId)/placeline_v2/?date=\(dateString)"
        HTNetworkRequest(method: .get, urlPath: urlPath, jsonParams: [:]).makeRequest { response in
            switch response.result {
            case .success:
                let placeline = HyperTrackPlaceline.fromJson(data: response.data!)
                guard let completionHandler = completionHandler else { return }
                completionHandler(placeline, nil)
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let htError = self.getHyperTrackError(response: response)
                completionHandler(nil, htError)
            }
        }
    }

 }

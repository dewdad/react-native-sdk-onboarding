//
//  HTTransmissionService.swift
//  HyperTrack
//
//  Created by ravi on 11/1/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import UIKit
import CocoaLumberjack

class HTTransmissionService: NSObject {

    static let sharedInstance = HTTransmissionService()
    let batchSize = 50
    var inProcessEventsList = [Int64]()
    
    private let networkOperationQueue = OperationQueue()
    var timer: Timer
    var transmissionControls : HTTransmissionControls? = nil
  
    override init() {
        self.timer = Timer()
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changeTransmissionControls),
                                               name: NSNotification.Name(rawValue: HTConstants.HTSDKControlsRefreshedNotification), object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onNetworkStateChange),
                                               name: NSNotification.Name(rawValue: HTConstants.HTNetworkStateChangedNotification), object: nil)

    }
    
    func onNetworkStateChange(){
        if HTSDKDataManager.sharedInstance.healthManager.currentRadioHealth?.networkState == HTNetworkState.disconnected{
            stopTimer()
        }else{
            setUpTransmissionControls()
        }
    }
    
    func setUpTransmissionControls(){
        self.transmissionControls = HTSDKControlsService.sharedInstance.getTransmissionControls()
        self.startTimer(batchDuration: self.transmissionControls?.batchDuration ?? HyperTrackSDKControls.defaultBatchDuration)
    }
    
    func changeTransmissionControls(){
        self.transmissionControls = HTSDKControlsService.sharedInstance.getTransmissionControls()
        self.resetTimer(batchDuration: self.transmissionControls?.batchDuration ?? HyperTrackSDKControls.defaultBatchDuration)
    }
    
    func postEvents(){
        objc_sync_enter(self)
        if let events = HTSDKDataManager.sharedInstance.getEvents(){
          let filteredEvents = self.filterEvents(events: events)
          let eventsBatches = divideEventsInBatches(events: filteredEvents)
            for eventsBatch in eventsBatches {
                let networkOperation = HTNetworkOperation.init(events: eventsBatch)
                self.addEventsToProcessingList(events: eventsBatch)
                let completionOp = BlockOperation.init(block: {
                    self.removeEventsFromProcessingList(events: events)
                })
                completionOp.addDependency(networkOperation)
            self.networkOperationQueue.addOperations([networkOperation,completionOp],waitUntilFinished: false)
            }
        }
        objc_sync_exit(self)
    }
    
    func addEventsToProcessingList(events: [HyperTrackEvent]){
        for event in events{
            if let eventId = event.id{
                if !self.inProcessEventsList.contains(eventId) {
                    self.inProcessEventsList.append(eventId)
                }
            }
        }
    }
    
    func removeEventsFromProcessingList(events: [HyperTrackEvent]){
        for event in events{
            if let eventId = event.id{
                if self.inProcessEventsList.contains(eventId) {
                    if let index = self.inProcessEventsList.index(of: eventId){
                        self.inProcessEventsList.remove(at: index)
                    }
                }
            }
        }
    }
    
    func filterEvents(events: [HyperTrackEvent]) -> [HyperTrackEvent]{
        var filteredEvents = [HyperTrackEvent]()
        for event in events{
            if let eventId = event.id{
                if !self.inProcessEventsList.contains(eventId) {
                    filteredEvents.append(event)
                }
            }
        }
        return filteredEvents
    }

    func divideEventsInBatches(events: [HyperTrackEvent])->[[HyperTrackEvent]]{
        var batches = [[HyperTrackEvent]]()
      
        var index = 0
        var batch: [HyperTrackEvent]? = nil
        for event in events {
            
            if index % batchSize == 0 {
                if let eventsBatch = batch {
                    batches.append(eventsBatch)
                }
                batch = [HyperTrackEvent]()
            }
            
            batch?.append(event)

            if (index == events.count - 1){
                if batch == nil {
                    batch = [HyperTrackEvent]()
                    batch?.append(event)
                }
                
                if let eventsBatch = batch {
                    batches.append(eventsBatch)
                }
            }
            
            index = index + 1
            
        }
        return batches
    }
    
    func startTimer(batchDuration: Double) {
        self.resetTimer(batchDuration: batchDuration)
    }
    
    func resetTimer(batchDuration: Double) {
        if self.timer.isValid {
            self.stopTimer()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: batchDuration, target: self, selector: #selector(self.postEvents), userInfo: Date(), repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func fire() {
        self.timer.fire()
    }
}

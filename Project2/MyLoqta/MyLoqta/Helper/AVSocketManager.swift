//
//  SocketManager.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SocketIO

class AVSocketManager: NSObject {
    
    typealias SocketConnectedBlock = () -> Void
    static let shareInst = AVSocketManager()
    let manager = SocketManager(socketURL: URL(string: APIEnvironment.socketUrl.rawValue)!, config:[.log(false), .reconnects(true)])
    var socket: SocketIOClient!
    var isSocketConnected = false
    var blockSocketConnected: SocketConnectedBlock?
    var timer: Timer?
    
    var isOnline = false
    var userId = 0
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        self.registerEvents()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ping), userInfo: nil, repeats: true)
    }
    
    @objc func ping() {
        let fromId = UserSession.sharedSession.userId
        //        if !fromId.isEmpty {
        //            socket.emit(AVSocketEvents.ping, fromId as SocketData)
        //        }
    }
    
    func connectSocket( completion: SocketConnectedBlock? = nil) {
        self.socket.connect()
    }
    
    func disconnectSocket()  {
        self.socket.disconnect()
    }
    
    func removeUserEvent(_ userId: String) {
        let eventName = "getOnlineStatus_" + userId
        socket.off(eventName)
    }
    
    func registerEvents() {
        
        socket.on(AVSocketEvents.connect) { (dataArray, ack) in
            print("Socket connected event --- >> \(dataArray) \(ack)")
            self.isSocketConnected = true
            Threads.performTaskInMainQueue {
                //notificationSocketConnected
                
            }
            //self.ping()
        }
        
        socket.on(clientEvent: .disconnect) { (dataArray, ack) in
            print("Socket disconnect event########## \(dataArray) \(ack)")
            self.isSocketConnected = false
        }
        
        socket.on(clientEvent: .error) { (dataArray, ack) in
            print("Socket error event \(dataArray) \(ack)")
        }
        
        socket.on(AVSocketEvents.disconnect) { (dataArray, ack) in
            print("Socket disconnect event++++++++++ \(dataArray) \(ack)")
            self.isSocketConnected = false
        }
        
        
        //Receive Driver Location
        socket.on(AVSocketEvents.getDriverData) { (dataArray, ack) in
            Threads.performTaskInMainQueue {
                
                print(dataArray)
                let driverData  = ["data" : dataArray]
                NotificationCenter.default.post(name: TrackNotification.driverData.name(), object: nil, userInfo: driverData)
                
            }
        }
    }
}
    
    
struct AVSocketEvents {
    static let connect = "connect"
    static let getDriverData = "getDriverData"
    static let disconnectEvent = "disconnect"
    static let disconnect = "disconnect"
}

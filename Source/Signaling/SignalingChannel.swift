//
//  SignalingChannel.swift
//  licode
//
//  Created by ztimc on 2018/9/20.
//  Copyright © 2018年 ztimc. All rights reserved.
//

import Foundation
import SocketIO

public protocol SignalingChannelDelegate {
    
    func connect(channel: SignalingChannel)
    
    func connectToRoom(channel: SignalingChannel, room: RoomMeta)
    
    func onAddStream(channel: SignalingChannel, stream: Stream)
    
    func onRemoveStream(channel: SignalingChannel, streamId: String)
    
    func onReceiveMessage(channel: SignalingChannel, message: SignalingMessage)
    
    func onReceiveData(channel: SignalingChannel, stream: Stream)
    
    func onUpdateAttributeStream(channel: SignalingChannel, stream: Stream)
    
    func error(channel: SignalingChannel, error: String)
    
    func disconnect(channel: SignalingChannel)
    
    
}

public class SignalingChannel {
    
    var manager: SocketManager!
    var token: Token!
    var room: RoomMeta!
    var delete: SignalingChannelDelegate!
    
    public init() {}
    
    public func connectByToken(encodedToken: String) {
        let decodedData = Data(base64Encoded: encodedToken)
        do {
            token = try Token(data: decodedData!)
            
            var url: URL!
            if(token.secure) {
                url = URL(string: "https://" + token.host)
            }else{
                url = URL(string: "http://" + token.host)
            }
            
            manager = SocketManager(socketURL: url, config: [.log(true), .forcePolling(false), .forceWebsockets(true), .secure(token.secure), .reconnects(false)])
            
        } catch  {
            print(error)
        }

        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, SocketAckEmitter) in
            //when connect, we send token
            socket.emitWithAck("token", self.token).timingOut(after: 0, callback: { data in
                
                let status = data[0] as! String
                
                if(status.elementsEqual("success")) {
                    
                    let jsonData = try! JSONSerialization.data(withJSONObject: data[1], options: .prettyPrinted)
                    
                    self.room = try! RoomMeta(data: jsonData)
                    self.delete.connectToRoom(channel: self, room: self.room)
                }else {
                    self.delete.error(channel: self, error: data[1] as! String)
                }
            })
        }
        
        socket.on(clientEvent: .disconnect) { (data, SocketAckEmitter) in
            self.delete.disconnect(channel: self)
        }
        socket.on(clientEvent: .error) { (data, SocketAckEmitter) in
            let error = data[0] as! String
            self.delete.error(channel: self, error: error)
        }
        
        socket.on(SocketEvent.onAddStream.rawValue) { (data, SocketAckEmitter) in
            let jsonData = try! JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
            let stream = try! Stream(data: jsonData)
            
            self.delete.onAddStream(channel: self, stream: stream)
        }
        socket.on(SocketEvent.onRemoveStream.rawValue) { (data, SocketAckEmitter) in
            let stream = data[0] as! Dictionary<String, Any>
            let streamId = stream["id"] as! String
            self.delete.onRemoveStream(channel: self, streamId: streamId)
        }
        socket.on(SocketEvent.signaling_message_erizo.rawValue) { (data, SocketAckEmitter) in
            
        }
        socket.on(SocketEvent.signaling_message_peer.rawValue) { ([Any], SocketAckEmitter) in
            
        }
        socket.on(SocketEvent.onDataStream.rawValue) { (data, SocketAckEmitter) in
            let jsonData = try! JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
            let stream = try! Stream(data: jsonData)
            
            self.delete.onReceiveData(channel: self, stream: stream)
        }
        socket.on(SocketEvent.onUpdateAttributeStream.rawValue) { (data, SocketAckEmitter) in
            let jsonData = try! JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
            let stream = try! Stream(data: jsonData)
            
            self.delete.onUpdateAttributeStream(channel: self, stream: stream)
        }
        
        socket.connect()
        
    }
}

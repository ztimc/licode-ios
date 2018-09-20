//
//  SocketEvent.swift
//  licode
//
//  Created by ztimc on 2018/9/20.
//  Copyright © 2018年 ztimc. All rights reserved.
//

import Foundation

enum SocketEvent: String {
    case onAddStream = "onAddStream"
    case signaling_message_erizo = "signaling_message_erizo"
    case signaling_message_peer = "signaling_message_peer"
    case onDataStream = "onDataStream"
    case onUpdateAttributeStream = "onUpdateAttributeStream"
    case onRemoveStream = "onRemoveStream"
    
}

//
//  ChatRoom.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/28.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatRoom {
    
    let latestMessageId: String
    let members: [String]
    let createdAt: Timestamp
    
    var documentId: String?
    var partnerUser: User?
    
    init(dic: [String: Any]) {
        
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

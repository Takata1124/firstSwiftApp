//
//  Message.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/30.
//

import Foundation
import Firebase
import FirebaseFirestore

class Message {
    
    let name: String
    let message: String
    let uid: String
    let createdAt: Timestamp
    
    var messageId: String?
    
    init(dic: [String: Any]) {
        
        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

//class MessageToString {
//    
//    
//}

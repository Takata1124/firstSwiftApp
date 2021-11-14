//
//  NewText.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/14.
//

import Foundation
import Firebase
import FirebaseFirestore

class NewText {
    
//    let name: String
    let uid: String
    let categorytitle: String
    let newText: String
    let TimeAt: String
    let DateAt: String
    let createdAt: Timestamp
    
    var NewtextId: String?
    
    init(dic: [String: Any]) {
        
//        self.name = dic["name"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.categorytitle = dic["categorytitle"] as? String ?? ""
        self.newText = dic["newText"] as? String ?? ""
        self.TimeAt = dic["TimeAt"] as? String ?? ""
        self.DateAt = dic["DateAt"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

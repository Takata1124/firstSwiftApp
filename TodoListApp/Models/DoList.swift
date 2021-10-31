//
//  DoList.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/01.
//

import Foundation
import Firebase
import FirebaseFirestore

class DoList {
    
//    let name: String
    let uid: String
    let dolisttitle: String
    let createdAt: Timestamp
    
    var dolistId: String?
    
    init(dic: [String: Any]) {
        
//        self.name = dic["name"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.dolisttitle = dic["dolisttitle"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

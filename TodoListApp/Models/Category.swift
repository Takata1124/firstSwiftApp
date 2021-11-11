//
//  Category.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/30.
//

import Foundation
import Firebase
import FirebaseFirestore

class Category {
    
//    let name: String
    let uid: String
    let categorytitle: String
    let createdAt: Timestamp
    
    
    var categoryId: String?
    
    init(dic: [String: Any]) {
        
//        self.name = dic["name"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.categorytitle = dic["categorytitle"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

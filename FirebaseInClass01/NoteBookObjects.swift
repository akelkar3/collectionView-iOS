//
//  NoteBookObjects.swift
//  FirebaseInClass01
//
//  Created by Ankit Kelkar on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import Foundation

class NoteBook: NSObject {
    var name:String
    var date:String
    var key:String
    
    init(name:String, date:String, key:String) {
        self.name = name
        self.date = date
        self.key = key
    }
}

class Note: NSObject {
    var post:String
    var date:String
    var key:String
    
    init(post:String, date:String, key:String) {
        self.post = post
        self.date = date
        self.key = key
    }
}

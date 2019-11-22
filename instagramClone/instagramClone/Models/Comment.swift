//
//  Comment.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Comment {
    private let postTitle: String
    var displayTitle: String {
        get {
            return "re: \(postTitle)"
        }
    }
    let body: String
    let id: String
    let creatorID: String
    let postID: String
    let dateCreated: Date?
    
    init(title: String, body: String, creatorID: String, postID: String, dateCreated: Date? = nil) {
        self.postTitle = title
        self.body = body
        self.creatorID = creatorID
        self.postID = postID
        self.id = UUID().description
        self.dateCreated = dateCreated
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let title = dict["title"] as? String,
            let body = dict["body"] as? String,
            let userID = dict["creatorID"] as? String,
            let postID = dict["postID"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.postTitle = title
        self.body = body
        self.creatorID = userID
        self.postID = postID
        self.id = id
        self.dateCreated = dateCreated
    }
    
    var fieldsDict: [String: Any] {
        return [
            "title": self.postTitle,
            "body": self.body,
            "creatorID": self.creatorID,
            "postID": self.postID,
        ]
    }
}

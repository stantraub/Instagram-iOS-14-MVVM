//
//  Post.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 11/8/20.
//

import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    let ownerImageUrl: String
    let ownerUsername: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""

        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
    }
}

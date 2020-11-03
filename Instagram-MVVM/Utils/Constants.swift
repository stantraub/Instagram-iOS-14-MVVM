//
//  Constants.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 10/30/20.
//

import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

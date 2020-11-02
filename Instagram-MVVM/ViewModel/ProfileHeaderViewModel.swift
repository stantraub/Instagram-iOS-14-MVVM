//
//  ProfileHeaderViewModel.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 10/30/20.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    
    
    init(user: User) {
        self.user = user
    }
}

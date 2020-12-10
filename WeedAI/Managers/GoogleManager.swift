//
//  GoogleManager.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/8/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

class GoogleManager {
    
    static let shared = GoogleManager()
    
    private init() {}
    
    public func reset() {
        email = nil
        userName = nil
        profileUrl = nil
        token = nil
    }
    
    var email: String?
    var userName: String?
    var token: String?
    var profileUrl: URL?
    
}

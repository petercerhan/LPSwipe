//
//  AuthStateController.swift
//  Albumzor
//
//  Created by Peter Cerhan on 9/17/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//

import Foundation

class AuthStateController {
    
    //MARK: - Dependencies
    
    let authService: SpotifyAuthManager
    
    //MARK: - State
    
    var sessionIsValid: Bool
    var token: String?
    
    //MARK: - Initialization
    
    init(authService: SpotifyAuthManager) {
        self.authService = authService
        authService.configureSpotifyAuth()
        
        sessionIsValid = authService.sessionIsValid()
        token = authService.getToken()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AuthStateController.sessionUpdated(_:)), name: Notification.Name("sessionUpdated"), object: nil)
    }
    
    //Receive notification center updates
    
    @objc func sessionUpdated(_ notification: Notification) {
        sessionIsValid = authService.sessionIsValid()
        token = authService.getToken()
    }
    
    //MARK: - Utils
    
    func deleteSession() {
        authService.deleteSession();
        UserDefaults.standard.removeObject(forKey: "SpotifySession")
    }
    
}


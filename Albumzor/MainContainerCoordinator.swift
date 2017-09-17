//
//  MainContainerCoordinator.swift
//  Albumzor
//
//  Created by Peter Cerhan on 9/16/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//

import Foundation

class MainContainerCoordinator {
    
    //MARK: - Dependencies
    
    let mainContainerViewController: ContainerViewController
    let authStateController: AuthStateController
    let userProfileStateController: UserProfileStateController
    let compositionRoot: CompositionRootProtocol
    
    //MARK: - Children
    
    var childCoordinators = [Any]()
    
    //MARK: - Initialization
    
    init(mainContainerViewController: ContainerViewController, authStateController: AuthStateController, userProfileStateController: UserProfileStateController, compositionRoot: CompositionRootProtocol) {
        self.mainContainerViewController = mainContainerViewController
        self.authStateController = authStateController
        self.userProfileStateController = userProfileStateController
        self.compositionRoot = compositionRoot
        
        
        print("User market: \(userProfileStateController.userProfile.userMarket)")
    }
    
    func start() {
        let vc = compositionRoot.composeOpenScene(mainContainerCoordinator: self)
        mainContainerViewController.show(viewController: vc, animation: .none)
    }
    
}

//MARK: - OpenSceneViewModelDelegate

extension MainContainerCoordinator: OpenSceneViewModelDelegate {
    func sceneComplete(_ openSceneViewModel: OpenSceneViewModel) {
        
        //Compose SpotifyLoginViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = appStoryboard.instantiateViewController(withIdentifier: "SpotifyLoginViewController") as! SpotifyLoginViewController
        vc.spotifyConnected = appDelegate.userProfile.spotifyConnected

        mainContainerViewController.show(viewController: vc, animation: .none)

        //somehow put these inside spotify login view controller
        vc.cancelButton.isHidden = true
        vc.controllerDelegate = self
        
        print("Authenticated: \(authStateController.sessionIsValid)")
    }
}

//MARK: - SpotifyViewControllerDelegate

extension MainContainerCoordinator: SpotifyLoginViewControllerDelegate {
    
    func loginSucceeded() {
        print("Delegate recognizes login succeeded")
        print("Authenticated: \(authStateController.sessionIsValid)")
    }
    
    func cancelLogin() {
        //remain on login page
    }
    
    
}


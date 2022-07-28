//
//  SceneDelegate.swift
//  TV Shows
//
//  Created by Infinum on 06.07.2022..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        // Create navigation controller in which we will embed our starting view controller
        let navigationController = UINavigationController()
        
        if let savedUserData = UserDefaults.standard.object(forKey: Constants.Defaults.userData.rawValue) as? Data {
            if let userData = try? JSONDecoder().decode(UserData.self, from: savedUserData) {
                let storyboard = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homeViewController.setUserData(user: userData.user, authInfo: userData.authInfo)
                navigationController.viewControllers = [homeViewController]
            } else {
                let storyboard = UIStoryboard(name: Constants.Storyboards.login, bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                navigationController.viewControllers = [loginViewController]
            }
            window?.rootViewController = navigationController
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


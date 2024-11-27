//
//  SceneDelegate.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 10/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    weak var tabBarControllerReference: UITabBarController?



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
       NotificationCenter.default.addObserver(
            forName: .tabBarControllerDidAppear,
            object: nil,
            queue: .main
        ) { notification in
            if let tabBarViewController = notification.object as? UITabBarController {
                print("Tab Bat Acquired")
                self.tabBarControllerReference = tabBarViewController
                var splitViewController:UISplitViewController? = tabBarViewController.viewControllers![3] as? UISplitViewController
                print(tabBarViewController.viewControllers![3])
                   
                let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
                navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
                splitViewController!.delegate = self
                
                let detailViewController = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? AlertsDetailViewController
                print (detailViewController)
                let leftNavController = splitViewController?.viewControllers.first as? UINavigationController
                let masterViewController = leftNavController?.viewControllers.first as? AlertsTableViewController
                print(masterViewController)
                masterViewController?.detailDelegate = detailViewController
                 
            }
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

    deinit {
        NotificationCenter.default.removeObserver(self, name: .tabBarControllerDidAppear, object: nil)
    }

}


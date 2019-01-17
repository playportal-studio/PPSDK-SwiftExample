//
//  AppDelegate.swift
//  PlayPortalSDK-Swift
//
//  Created by Lincoln Fraley on 1/3/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import UIKit
import PPSDK_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PlayPortalLoginDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PlayPortalAuth.shared.configure(forEnvironment: env, withClientId: clientId, andClientSecret: clientSecret, andRedirectURI: redirect)
        authenticate()
        return true
    }

    func authenticate() {
        PlayPortalAuth.shared.isAuthenticated(loginDelegate: self) { [weak self] error, userProfile in
            guard let strongSelf = self else { return }
            if let userProfile = userProfile {
                //  User is authenticated, go to profile page
                print("User authenticated successfully")
                guard let tab = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab") as? UITabBarController
                    , let controllers = tab.viewControllers
                    , let profile = controllers[0] as? ProfileViewController
                    else {
                        return
                }
                profile.userProfile = userProfile
                strongSelf.window?.rootViewController = tab
                
                PlayPortalNotifications.shared.register { error in
                    if let error = error {
                        print("error requesting notifications")
                        print(error)
                    } else {
                        print("notifications setup")
                    }
                }
            } else if let error = error {
                print("Error during authentication: \(error)")
            } else {
                //  Not authenticated, open login view controller
                print("User not authenticated, go to login")
                guard let login = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as? LoginViewController else {
                    return
                }
                strongSelf.window?.rootViewController = login
            }
        }
    }
    
    //  This method must be implemented so the sdk can handle redirects from playPORTAL SSO
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        PlayPortalAuth.shared.open(url: url)
        return true
    }
    
    func didFailToLogin(with error: Error) {
        print("Login failed during SSO flow: \(error)")
    }
    
    func didLogout(with error: Error) {
        print("Error occurred during logout: \(error)")
    }
    
    func didLogoutSuccessfully() {
        print("Logged out successfully!")
        authenticate()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        PlayPortalNotifications.shared.didRegisterForRemoteNotifications(withDeviceToken: deviceToken) { error in
            if let error = error {
                print("error requesting notifications")
                print(error)
            } else {
                print("notifications setup")
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("received notification")
    }
}


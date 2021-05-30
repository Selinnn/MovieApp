//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var remoteConfig: RemoteConfig!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        self.fetchRemoteConfig(launchOptions: launchOptions)
        return true
    }
    
    func fetchRemoteConfig(launchOptions:[UIApplication.LaunchOptionsKey: Any]?) {
        
        let expirationDuration: TimeInterval
        expirationDuration = 0

        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                RemoteConfig.remoteConfig().activate(completion: { (result,error) in
                    DispatchQueue.main.async {
                    Config.API_URL = self.remoteConfig["API_URL"].stringValue ?? ""
                    Config.SPLASH_TEXT = self.remoteConfig["SPLASH_TEXT"].stringValue ?? ""
                    }
                    
                    self.showMain()
                })
                
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
        }
    }
    

}

@objc extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension AppDelegate {
    
    func showMain() {
        
    DispatchQueue.main.async {
      let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashVC")
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .fullScreen
        if UIApplication.topViewController() != nil {
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                }else{
                    self.window?.rootViewController = vc
                }
            }
        }
}



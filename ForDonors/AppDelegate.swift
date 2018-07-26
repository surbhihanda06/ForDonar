//
//  AppDelegate.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import ReachabilitySwift
import PushKit

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn
import LinkedinSwift
import TwitterKit
import Fabric
import Crashlytics
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController:UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        if userId == 0
        {
            let NextController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navController = UINavigationController(rootViewController: NextController)
            self.navController?.isNavigationBarHidden = true
            self.window!.rootViewController = self.navController
            self.window!.makeKeyAndVisible()
        }
        else
        {
            let NextController = HomeController(nibName: "HomeController", bundle: nil)
            self.navController = UINavigationController(rootViewController: NextController)
            self.navController?.isNavigationBarHidden = true
            self.window!.rootViewController = self.navController
            self.window!.makeKeyAndVisible()
        }
        
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.shared.enable = true
        registerForRemoteNotification()
        FirebaseApp.configure()
        addReachability()
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_iu3GIFVed8ElRFLjxTdCVUYo"
        
        GIDSignIn.sharedInstance().clientID = "818078003112-ddnoeif3ubr54q4a7pq4ud67hu4042ad.apps.googleusercontent.com"
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"FGxVah8hgOI5AfPZ9DCu0VSiu", consumerSecret:"UiniRMyAphs371U6RyNUL4vJiQkNRjT925uyT2njufy9aSnEK0")
        
        //BTAppSwitch.setReturnURLScheme("com.ConnectBudLLC.ConnectBud.payments")
        Fabric.with([Crashlytics.self,Answers.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    {
        if url.scheme?.localizedCaseInsensitiveCompare("fb166892517443129") == .orderedSame {
            return FBSDKApplicationDelegate.sharedInstance().application(
                app,
                open: url as URL!,
                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                annotation: options[UIApplicationOpenURLOptionsKey.annotation]
            )
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("com.googleusercontent.apps.818078003112-ddnoeif3ubr54q4a7pq4ud67hu4042ad") == .orderedSame {
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                        annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("li4795924") == .orderedSame
        {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("twitterkit-FGxVah8hgOI5AfPZ9DCu0VSiu") == .orderedSame
        {
            TWTRTwitter.sharedInstance().application(app, open: url, options: options)
            return true
        }
        
        
        
        return false
    }
    
    // If you support iOS 7 or 8, add the following method.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if url.scheme?.localizedCaseInsensitiveCompare("fb166892517443129") == .orderedSame
         {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("com.googleusercontent.apps.818078003112-ddnoeif3ubr54q4a7pq4ud67hu4042ad") == .orderedSame {
            
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication: sourceApplication,
                                                        annotation: annotation)
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("li4795924") == .orderedSame
        {
            return LinkedinSwiftHelper.application(application,
                                                   open: url,
                                                   sourceApplication: sourceApplication,
                                                   annotation: annotation
            )
        }
        else if url.scheme?.localizedCaseInsensitiveCompare("twitterkit-FGxVah8hgOI5AfPZ9DCu0VSiu") == .orderedSame
        {
            //TWTRTwitter.sharedInstance().application(<#T##application: UIApplication##UIApplication#>, open: <#T##URL#>, options: <#T##[AnyHashable : Any]#>)
            return true
        }
        return false
    }

    
    func addReachability()
    {
        reachability = Reachability.init()
        NotificationCenter.default.addObserver(self,selector:#selector(checkForReachability(_:)),name: ReachabilityChangedNotification,object: reachability)
        try! reachability?.startNotifier()
    }
    
    @objc func checkForReachability(_ notification:NSNotification)
    {
        let networkReachability = notification.object as! Reachability;
        let remoteHostStatus = networkReachability.currentReachabilityStatus
        var msg = ""
        if (remoteHostStatus == .notReachable)
        {
            print("Not Reachable")
            msg = "No Internet Connection!"
        }
        else if (remoteHostStatus == .reachableViaWiFi)
        {
            print("Reachable via Wifi")
            msg = "Now you are connected via Wifi!"
        }
        else if (remoteHostStatus == .reachableViaWWAN)
        {
            print("Reachable via WWAN")
            msg = "Now you are connected via Mobile Network!"
        }
        else
        {
            print("Reachable via Other Connection")
            msg = "Now you are connected!"
        }
        perform(#selector(callTransparentWindow(strMsg:)), with: msg, afterDelay: 0.3)
    }
    
    @objc func callTransparentWindow(strMsg:String)
    {
        if let vc = UIApplication.topViewController()
        {
            Validation.showTransparentWindow(sender: vc, strMsg: strMsg)
        }
        
    }
    
    //MARK:  Normal Push notification registration
    func registerForRemoteNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //MARK: Push notification registration delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let userDefaults = Foundation.UserDefaults.standard
        if(deviceTokenString.count>0)
        {
            userDefaults.set(deviceTokenString, forKey: "pushNotificationID")
        }
        else
        {
            userDefaults.set("", forKey: "pushNotificationID")
        }
        userDefaults.synchronize()
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register: \(error)")//print error in debugger console
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            //let DEVICE_IS_SIMULATOR = true
            let deviceTokenString = "550E6CC4F2D764B239E4BD0023DF2A3FD8D5E9A198BE8DBE8AF495F086F8E8B5"
        #else
            //let DEVICE_IS_SIMULATOR = false
            let deviceTokenString = ""
        #endif
        
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(deviceTokenString, forKey: "pushNotificationID")
        userDefaults.synchronize()
    }

}


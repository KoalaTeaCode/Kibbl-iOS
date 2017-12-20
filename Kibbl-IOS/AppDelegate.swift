
//  AppDelegate.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/21/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyBeaver
let log = SwiftyBeaver.self
import IQKeyboardManager
import UserNotifications
import Firebase
import FacebookCore
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Setup swifty beaver
        let console = ConsoleDestination()
        log.addDestination(console) // add to SwiftyBeaver
        
        // Setup realm configuration
        // Always turn this off before release
        migrateRealmDatabase()
        
        Fabric.with([Crashlytics.self])
        
        UITabBar.appearance().tintColor = Stylesheet.Colors.base
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        IQKeyboardManager.shared().isEnabled = true
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        // Direct connection to FCM bypassing APN
        // This is a good work around for iOS 9 and doesn't break iOS 10+
        Messaging.messaging().shouldEstablishDirectChannel = true
        //@TODO: if we us direct connection we don't need to use Notification center delegate for in app notifications
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        API.sharedInstance.registerForPushNotifications(application)
        deleteOldRealmObjects()
        API.sharedInstance.createDefaultData()
        
        // Setup Facebook
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        
        let placesApiKey = "AIzaSyAaDBnQijBblxLVMvLG82oKVwZTUC4z0cA"
        GMSPlacesClient.provideAPIKey(placesApiKey)
        GMSServices.provideAPIKey(placesApiKey)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = CustomTabViewController()
        rootVC.view.backgroundColor = .white
        let vc = CustomNavigationController(rootViewController: rootVC)
        vc.view.backgroundColor = .white
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
        
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

        // Clear badge numbre
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func migrateRealmDatabase() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        log.info(config.fileURL!)
    }
}

extension AppDelegate {
    // Facebook
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Notifications
    
    //@TODO: make sure iOS9 is receiving notifications in foreground

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        guard let token = Messaging.messaging().fcmToken else { return }
        User.getActiveUser()?.update(deviceToken: token)
        API.sharedInstance.setPushNotifications(to: true, deviceToken: token)
        Messaging.messaging().apnsToken = deviceToken
        
        log.info("FCM token: \(token ?? "where are you")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.info("\(error.localizedDescription)")
    }
    
    // Receive Notifications
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        log.info("Did receive notification with this info: \(userInfo)")
        
        // If push notification about updates
        // @TODO: Check message ID -> userInfo[gcmMessageIDKey]
        
        // Get updates
        API.sharedInstance.getUpdates()
        incrementBadgeNumberBy(badgeNumberIncrement: 1)
        
        // Show update screen
        // @TODO: Navigate to updates view
        
        // Create local notifications
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        log.info("Tapped in notification")
        
        // If push notification about updates
        // @TODO: Check message ID -> userInfo[gcmMessageIDKey]
        
        // Get updates
        API.sharedInstance.getUpdates()
        
        // Show update screen
        // @TODO: Navigate to updates view
        
        // Create local notifications
    }
    
    //Auto presents local notifications for iOS 10+
    //This is key callback to present notification while the app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        log.info("Notification being triggered in foreground")
        
        // @TODO: incrememnt badge number
        incrementBadgeNumberBy(badgeNumberIncrement: 1)
        
        completionHandler([.alert,.sound,.badge])
        
        // If push notification about updates
        // @TODO: Check message ID -> userInfo[gcmMessageIDKey]
        
        // Get updates
        API.sharedInstance.getUpdates()
        
        // Show update screen
        // @TODO: Navigate to updates view
        
        // Create local notifications
    }
    
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        print(currentBadgeNumber)
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }

}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        log.info("Firebase registration token: \(fcmToken)")
    }
    
    // @TODO: This isn't doing anything in iOS 10+ (maybe)
    // Need to check if this is for iOS 9
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        // @TODO: Creat local notification from data
        log.info("Received data message: \(remoteMessage.appData)")
        API.sharedInstance.getUpdates()
    }
    // [END ios_10_data_message]
}

extension AppDelegate {
    func deleteOldRealmObjects() {
        let realm = try! Realm()
        log.debug("DELETing")
        try! realm.write {
            realm.delete(EventModel.all().filter("favorited = false"))
            realm.delete(PetModel.all().filter("favorited = false"))
            realm.delete(ShelterModel.all().filter("following = false"))
            realm.delete(UpdatesModel.all())
            realm.delete(FilterModel.all())
        }
    }
}

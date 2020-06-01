//
//  ApplicationDelegate.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/5.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

class FXApplicationDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    ///可嵌入委托做转发，让各个需要在AppDelegate中添加事件的控件能统一管理，若有版本差异，统一用最新的
    var delegates:[UIApplicationDelegate]?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        _ = self.application(application, didFinishLaunchingWithOptions: nil)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.delegates?.forEach( { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) })
        return true
    }
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.delegates?.forEach( { _ = $0.application?(application, willFinishLaunchingWithOptions: launchOptions) })
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationDidBecomeActive?(application) })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationWillResignActive?(application) })
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return self.application(application, open: url, sourceApplication: nil, annotation: 0)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let ds = self.delegates, ds.count > 0 {
            for d in ds {
                if d.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation) ?? false {
                    return true
                }
            }
        }
        return false
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let ds = self.delegates, ds.count > 0 {
            for d in ds {
                if d.application?(app, open: url, options: options) ?? false {
                    return true
                }
            }
        }
        return false
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationDidReceiveMemoryWarning?(application) })
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationWillTerminate?(application) })
    }
    
    func applicationSignificantTimeChange(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationSignificantTimeChange?(application) })
    }
    
    func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
         self.delegates?.forEach( { $0.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration) })
    }
    
    func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
         self.delegates?.forEach( { $0.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation) })
    }
    
    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect){
        self.delegates?.forEach( { $0.application?(application, willChangeStatusBarFrame: newStatusBarFrame) })
    }
    
    func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect){
        self.delegates?.forEach( { $0.application?(application, didChangeStatusBarFrame: oldStatusBarFrame) })
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        self.delegates?.forEach( { $0.application?(application, didRegister: notificationSettings) })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.delegates?.forEach( { $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        self.delegates?.forEach( { $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        self.delegates?.forEach( { $0.application?(application, didReceiveRemoteNotification: userInfo) })
    }
    
   func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        self.delegates?.forEach( { $0.application?(application, didReceive: notification) })
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler) })
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler) })
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler) })
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleActionWithIdentifier: identifier, for: notification, withResponseInfo:responseInfo ,completionHandler: completionHandler) })
    }
    
//    @available(iOS 7.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.delegates?.forEach( { $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) } )
    }
//    @available(iOS 7.0, *)
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.delegates?.forEach( { $0.application?(application, performFetchWithCompletionHandler: completionHandler) } )
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.delegates?.forEach( { $0.application?(application, performActionFor:shortcutItem, completionHandler: completionHandler) } )
    }
    
//    @available(iOS 7.0, *)
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleEventsForBackgroundURLSession:identifier, completionHandler: completionHandler) } )
    }
    
    @available(iOS 8.2, *)
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        self.delegates?.forEach( { $0.application?(application, handleWatchKitExtensionRequest:userInfo, reply: reply) } )
    }
    
    @available(iOS 9.0, *)
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationShouldRequestHealthAuthorization?(application) } )
    }
    /* 有问题，先不处理
    @available(iOS 11.0, *)
    func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
        self.delegates?.forEach( { $0.application?(application, handle: intent,completionHandler: completionHandler) } )
    }
    */
//    @available(iOS 4.0, *)
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationDidEnterBackground?(application) } )
    }
    
//    @available(iOS 4.0, *)
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationWillEnterForeground?(application) } )
    }
    
//    @available(iOS 4.0, *)
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationProtectedDataWillBecomeUnavailable?(application) } )
    }
    
//    @available(iOS 4.0, *)
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        self.delegates?.forEach( { $0.applicationProtectedDataDidBecomeAvailable?(application) } )
    }
    
    /*特殊操作，全局只能有一个处理的，不处理，交由APP自己处理
//    @available(iOS 6.0, *)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
    }
//    @available(iOS 8.0, *)
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
 
    }
 
    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController?
    
    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool
    
    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool
    
    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder)
    
    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder)
    
    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool
    
    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    
    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error)
    
    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity)
    
    @available(iOS 10.0, *)
    optional func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata)
     */
}


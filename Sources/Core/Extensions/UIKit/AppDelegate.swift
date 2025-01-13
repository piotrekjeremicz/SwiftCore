//
//  AppDelegate.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.11.2024.
//

import SwiftUI

@Observable @MainActor
public class AppDelegate: NSObject, UIApplicationDelegate {
    private var finishLaunchingWithOptionsClosures = [(UIApplication, [UIApplication.LaunchOptionsKey : Any]?) -> Void]()
    private var registerForRemoteNotificationsWithDeviceTokenClosures = [(UIApplication, Data) -> Void]()
    private var failToRegisterForRemoteNotificationsWithErrorClosures = [(UIApplication, Error) -> Void]()
    
    public func finishLaunchingWithOptions(_ closure: @escaping (UIApplication, [UIApplication.LaunchOptionsKey : Any]?) -> Void) {
        finishLaunchingWithOptionsClosures.append(closure)
    }
    
    public func registerForRemoteNotificationsWithDeviceToken(_ closure: @escaping (UIApplication, Data) -> Void) {
        registerForRemoteNotificationsWithDeviceTokenClosures.append(closure)
    }
    
    public func failToRegisterForRemoteNotificationsWithError(_ closure: @escaping (UIApplication, Error) -> Void) {
        failToRegisterForRemoteNotificationsWithErrorClosures.append(closure)
    }
}

extension AppDelegate {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        finishLaunchingWithOptionsClosures.forEach { $0(application, launchOptions) }
        
        return true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registerForRemoteNotificationsWithDeviceTokenClosures.forEach { $0(application, deviceToken) }
        
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        failToRegisterForRemoteNotificationsWithErrorClosures.forEach { $0(application, error) }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async { }
}

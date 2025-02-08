//
//  AppDelegate.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.11.2024.
//

import AsyncAlgorithms
import SwiftUI

@Observable @MainActor
public class AppDelegate: NSObject, UIApplicationDelegate {
    public typealias FinishLaunchingWithOptionsClosure = (UIApplication, [UIApplication.LaunchOptionsKey : Any]?) -> Bool
    public typealias DeviceTokenRegistrationClosure = (UIApplication, Data) -> Void
    public typealias RemoteNavigationRegistrationFailedClosure = (UIApplication, Error) -> Void
    public typealias RemoteNotificationReceivedClosure = (UIApplication, [AnyHashable : Any]) async -> UIBackgroundFetchResult
    
    private var finishLaunchingWithOptionsClosures = [FinishLaunchingWithOptionsClosure]()
    private var registerForRemoteNotificationsWithDeviceTokenClosures = [DeviceTokenRegistrationClosure]()
    private var failToRegisterForRemoteNotificationsWithErrorClosures = [RemoteNavigationRegistrationFailedClosure]()
    private var didReceiveRemoteNotificationClosures = [RemoteNotificationReceivedClosure]()
    
    public func finishLaunchingWithOptions(_ closure: @escaping FinishLaunchingWithOptionsClosure) {
        finishLaunchingWithOptionsClosures.append(closure)
    }
    
    public func registerForRemoteNotificationsWithDeviceToken(_ closure: @escaping DeviceTokenRegistrationClosure) {
        registerForRemoteNotificationsWithDeviceTokenClosures.append(closure)
    }
    
    public func failToRegisterForRemoteNotificationsWithError(_ closure: @escaping RemoteNavigationRegistrationFailedClosure) {
        failToRegisterForRemoteNotificationsWithErrorClosures.append(closure)
    }
    
    public func didReceiveRemoteNotification(_ closure: @escaping RemoteNotificationReceivedClosure) {
        didReceiveRemoteNotificationClosures.append(closure)
    }
}

extension AppDelegate {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        return finishLaunchingWithOptionsClosures
            .map { $0(application, launchOptions) }
            .contains(false) ? false : true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registerForRemoteNotificationsWithDeviceTokenClosures.forEach { $0(application, deviceToken) }
        
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        failToRegisterForRemoteNotificationsWithErrorClosures.forEach { $0(application, error) }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        var results = [UIBackgroundFetchResult]()
        
        for item in didReceiveRemoteNotificationClosures {
            results.append(await item(application, userInfo))
        }
        
        return results
            .sorted(by: { $0.rawValue > $1.rawValue })
            .first ?? .noData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async { }
}

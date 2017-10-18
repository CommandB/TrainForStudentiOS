//
//  AppDelegate.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import UIKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{

    var window: UIWindow?
    //支持当前controller横屏
    var blockRotation = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0;
        // Override point for customization after application launch.
        
//        registerForPushNotifications(launchOptions)
        registerJPushService(launchOptions)
        
        let sp = UserDefaults.standard.string(forKey: LoginInfo.server_port.rawValue)
        let pp = UserDefaults.standard.string(forKey: LoginInfo.portal_port.rawValue)
        let token = UserDefaults.standard.string(forKey: LoginInfo.token.rawValue)
        
        if sp != nil {
            SERVER_PORT = sp!
        }
        if pp != nil {
            PORTAL_PORT = pp!
        }
        if token != nil{
            r_token = token!
        }
        
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
        application.applicationIconBadgeNumber = 0;
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //判断缓存中是否存在token
        let token = UserDefaults.standard.string(forKey: LoginInfo.token.rawValue)
        if token == nil{
            myPresentView((self.window?.rootViewController)!, viewName: "loginView")
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if blockRotation{
            return UIInterfaceOrientationMask.all
        }else{
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //推送服务注册成功时调用
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //let token = String.init(data: deviceToken, encoding: .)
//        print(deviceToken.description)
        let nsData = NSData(data: deviceToken)
        print("推送服务注册成功,token=" + nsData.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: ""))
        //47e5c3bcbcc12aea61f6653940a730124d3f42db2681a8a804922319e34fd7f8
        //47e5c3bcbcc12aea61f6653940a730124d3f42db2681a8a804922319e34fd7f8
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    //推送服务注册失败时调用
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("推送服务注册失败...")
    }
    
    //当有消息推送到设备并且点击消息启动app时会调用
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("收到新消息Active\(userInfo)")
        if application.applicationState == .active{
            //表示从前台接受消息
            print("从前台接受消息")
        }else{
            //表示从后台接受消息后进入app
            print("从后台接受消息后进入app")
        }
        
    }
    
    
    //注册极光推送
    func registerJPushService(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "177ce40228242a0009b41965",
                           channel: "app store",
                           apsForProduction: true)

    }
    
    //注册推送服务
    func registerForPushNotifications(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *){
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types  = UNAuthorizationOptions(arrayLiteral: [.alert , .badge , .sound ])
            notifiCenter.requestAuthorization(options: types, completionHandler: {
                (flag, err) in
                if flag{
                    print("ios request notification success")
                }else{
                    print("ios 10 request notification fail")
                }
            })
            
        }else{
            let setting = UIUserNotificationSettings.init(types: [.alert , .badge , .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            //UIApplication.shared.scheduleLocalNotification()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //处理前台接受通知的代理方法
    @available(iOS 10.0 , *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("userInfo 10 = \(userInfo)")
//        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler([.sound , .alert])
        
    }
    
    //处理后台点击通知的代理方法
    @available(iOS 10.0 , *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo 10 = \(userInfo)")
        
        //处理本地消息通知
//        center.removeAllDeliveredNotifications()
//        center.removeAllPendingNotificationRequests()
        
        print("bagge:\(UIApplication.shared.applicationIconBadgeNumber)")
//        UIApplication.shared.applicationIconBadgeNumber = 0
        print("bagge:\(UIApplication.shared.applicationIconBadgeNumber)")
        
    }

}

extension AppDelegate : JPUSHRegisterDelegate{
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        
    }
    
}


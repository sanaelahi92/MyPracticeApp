//
//  AppDelegate.swift
//  MyPracticeApp
//
//  Created by Welltime on 17/06/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent,  animated: true)
        
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        
        PayPalMobile .initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction:"",
            PayPalEnvironmentSandbox: "APP-80W284485P519543T"])

        
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if !(userDefaults.objectForKey("REMINDER_DATE") == nil) {
            var calendar: NSCalendar = NSCalendar.currentCalendar()
            var components: NSDateComponents = NSDateComponents()
            components.month = 1
            var reminder_date: NSDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])!
            var formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            var rem_date_string: String = formatter.stringFromDate(reminder_date)
            // Adding version number to NSUserDefaults for first version:
            userDefaults.setObject(rem_date_string, forKey: "REMINDER_DATE")
        }
        //appearance] setTintColor:[UIColor whiteColor]];
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


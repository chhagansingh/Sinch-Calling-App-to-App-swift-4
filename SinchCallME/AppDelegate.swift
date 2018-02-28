//
//  AppDelegate.swift
//  SinchCallME
//
//  Created by Chhagan Singh on 28/02/18.
//  Copyright © 2018 Chhagan Singh. All rights reserved.
//

import UIKit
import Sinch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SINClientDelegate {

    var window: UIWindow?
    var client: SINClient!

    var player: AVAudioPlayer?
    
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        


        func onUserDidLogin(_ userId: String)
        {
           // self.push?.registerUserNotificationSettings()
            print("calling initSinch")
            self.initSinchClient(withUserId: userId)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLoginNotification"), object: nil, queue: nil, using: {(_ note: Notification) -> Void in
            print("Got notification")
            let userId = note.userInfo!["userId"] as? String
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            onUserDidLogin(userId!)
        })
        
        return true
    }
    

    
    func initSinchClient(withUserId userId: String) {
        
        if client == nil {
            print("initializing client 2")
            client = Sinch.client(withApplicationKey: "<application key>",
                                  applicationSecret: "<application secret>",
                                  environmentHost: "sandbox.sinch.com",
                                  userId: "<user id>")
            client.delegate = self
            client.setSupportCalling(true)
            client.start()
            client.startListeningOnActiveConnection()

        }
    }


  

    
    //SINCallClient delegates
    func clientDidStart(_ client: SINClient!) {
        print("Sinch client started successfully (version: \(Sinch.version()) with userid \(client.userId)")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("Sinch client error: \(String(describing: error?.localizedDescription))")
    }
    
    func client(_ client: SINClient, logMessage message: String, area: String, severity: SINLogSeverity, timestamp: Date) {
        
        print("\(message)")
        
    }
    
}


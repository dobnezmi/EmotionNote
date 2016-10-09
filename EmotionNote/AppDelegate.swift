//
//  AppDelegate.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/07/31.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.userDefaultDidChange(notification:)), name: UserDefaults.didChangeNotification, object: nil)
        
        return true
    }
    
    func userDefaultDidChange(notification: Notification) {
        let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!
        let ud = UserDefaults(suiteName: groupSuiteName)
        let emotions = ud?.array(forKey: "emotions") as? [Int]
        let times = ud?.array(forKey: "times") as? [Date]
        
        if let emotions = emotions, let times = times {
            if emotions.count == times.count {
                for i in 0 ..< emotions.count {
                    let emote = emotions[i]
                    let at = times[i]
                    dataStore.storeEmotion(emotion: Emotion(rawValue: emote)!, emoteAt: at)
                }
            }
        }
        
        ud?.removeObject(forKey: "emotions")
        ud?.removeObject(forKey: "times")
    }
}


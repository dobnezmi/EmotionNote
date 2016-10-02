//
//  EmotionDataStoreRealm.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/18.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

final class EmotionDataStoreRealm: EmotionDataStore {
    static private var _instance: EmotionDataStoreRealm = EmotionDataStoreRealm()
    static var sharedInstance: EmotionDataStore {
        return _instance
    }
    var realm: Realm? = try? Realm()
    
    // MARK: -- Fetch
    // 指定日付のエモーションデータ取得
    func emotionsWithDate(targetDate: Date, completion: ([EmotionEntity])->()) {
        let stDate = Date.at(year: targetDate.year,
                             month: targetDate.month,
                             day: targetDate.day,
                             hour: 0, minute: 0, second: 0)
        let edDate = Date.at(year: targetDate.year,
                             month: targetDate.month,
                             day: targetDate.day,
                             hour: 23, minute: 59, second: 59)
            
        var emotes: [EmotionEntity] = []
        if let results = realm?.objects(EmotionEntity.self)
                                .filter("emoteAt >= %@ AND emoteAt <= %@", stDate, edDate) {
            for result in results {
                emotes.append(result)
            }
        }
            
        completion(emotes)
    }
    
    // 指定期間の時間帯別エモーションデータ取得
    func emotionsWithPeriodPerHours(period: EmotionPeriod, completion: ([EmotionCount])->()) {

        var resultsPerHour: [EmotionCount] = []
        // 24時間分0で初期化
        for _ in 0...23 {
            resultsPerHour.append(EmotionCount())
        }
            
        var queryResult: Results<EmotionEntity>?
        if let filterStr = filterStringWithPeriod(period: period) {
            queryResult = realm?.objects(EmotionEntity.self).filter(filterStr)
        } else {
            queryResult = realm?.objects(EmotionEntity.self)
        }
            
        if let results = queryResult {
            for result in results {
                switch(result.emotion) {
                case Emotion.Happy.rawValue:
                    resultsPerHour[result.hour].happyCount += 1
                case Emotion.Enjoy.rawValue:
                    resultsPerHour[result.hour].enjoyCount += 1
                case Emotion.Sad.rawValue:
                    resultsPerHour[result.hour].sadCount += 1
                case Emotion.Frustrated.rawValue:
                    resultsPerHour[result.hour].frustCount += 1
                default:
                    break
                }
            }
        }
            
        completion(resultsPerHour)
    }
    
    // 曜日別エモーションデータ取得
    func emotionsWithWeek(period: EmotionPeriod, completion: ([EmotionCount])->()) {

        var resultsWeekday: [EmotionCount] = []
        // 0で初期化
        for _ in 0...6 {
            resultsWeekday.append(EmotionCount())
        }
            
        var queryResult: Results<EmotionEntity>?
        if let filterStr = filterStringWithPeriod(period: period) {
            queryResult = realm?.objects(EmotionEntity.self).filter(filterStr)
        } else {
            queryResult = realm?.objects(EmotionEntity.self)
        }
            
        if let results = queryResult {
                
            for result in results {
                print(result.weekday)
                switch(result.emotion) {
                case Emotion.Happy.rawValue:
                    resultsWeekday[result.weekday].happyCount += 1
                case Emotion.Enjoy.rawValue:
                    resultsWeekday[result.weekday].enjoyCount += 1
                case Emotion.Sad.rawValue:
                    resultsWeekday[result.weekday].sadCount += 1
                case Emotion.Frustrated.rawValue:
                    resultsWeekday[result.weekday].frustCount += 1
                default:
                    break
                }
            }
        }
        completion(resultsWeekday)
    }
    
    // 指定期間のエモーションデータ取得
    func emotionsWithPeriod(period: EmotionPeriod, completion: (EmotionCount)->()) {

        var queryResult: Results<EmotionEntity>?
            
        if let predicate = filterStringWithPeriod(period: period) {
            queryResult = realm?.objects(EmotionEntity.self).filter(predicate)
        } else {
            queryResult = realm?.objects(EmotionEntity.self)
        }
            
        if let results = queryResult {
            let emoteCount = results.reduce(EmotionCount(), { count, result in
                                                    
                switch(result.emotion) {
                case Emotion.Happy.rawValue:
                    return count.addHappy()
                case Emotion.Enjoy.rawValue:
                    return count.addEnjoy()
                case Emotion.Sad.rawValue:
                    return count.addSad()
                case Emotion.Frustrated.rawValue:
                    return count.addFrustrate()
                default:
                    return count
                                                    }
            })
            completion(emoteCount)
        }
    }
    
    private func filterStringWithPeriod(period: EmotionPeriod) -> NSPredicate? {
        let today = Date()
        
        switch(period) {
        case .All:
            return nil
        case .Month:
            let stDate = today.add(month: -1)
            return NSPredicate(format: "emoteAt >= %@ AND emoteAt <= %@", stDate as CVarArg, today as CVarArg)
        case .Week:
            let stDate = today.add(week: -1)
            return NSPredicate(format: "emoteAt >= %@ AND emoteAt <= %@", stDate as CVarArg, today as CVarArg)
        }
    }
    
    // MARK: -- Store/Update
    // エモーション保存
    func storeEmotion(emotion: Emotion) {
        let emoteObject = EmotionEntity()
        emoteObject.emoteAt = Date()
        emoteObject.emotion = emotion.rawValue
        emoteObject.hour    = emoteObject.emoteAt.hour
        emoteObject.weekday = emoteObject.emoteAt.weekday - 1
        
        try! realm?.write {
            realm?.add(emoteObject)
        }
    }
    
    // MARK: -- Delete
    func clearAll() {
        try! realm?.write {
            realm?.deleteAll()
        }
    }
}

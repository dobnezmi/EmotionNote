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

final class EmotionDataStoreRealm {
    
    static private var _realm: Realm?
    static private var realm: Realm? {
        if _realm == nil {
            _realm = try? Realm()
        }
        return _realm
    }
    
    //タイムスタンプ、曜日、時間、感情
    //（時間と感情のプロット、１日単位）、（時間と感情の統計、今週、１ヶ月、累計）、（感情の統計、円の大きさ、今週、１ヶ月、累計）
    
    // MARK: -- Fetch
    
    // 指定日付のエモーションデータ取得
    class func emotionsWithDate(targetDate: Date) -> [EmotionEntity] {
        let stDate = Date.at(year: targetDate.year, month: targetDate.month, day: targetDate.day, hour: 0, minute: 0, second: 0)
        let edDate = Date.at(year: targetDate.year, month: targetDate.month, day: targetDate.day, hour: 23, minute: 59, second: 59)
        
        var emotes: [EmotionEntity] = []
        if let results = realm?.objects(EmotionEntity.self).filter("emoteAt >= %@ AND emoteAt <= %@", stDate, edDate) {
            for result in results {
                emotes.append(result)
            }
        }
        return emotes
    }
    
    class func rx_emotionsWithDate(targetDate: Date) -> Observable<[EmotionEntity]> {
        return Observable.create { observer in
            let stDate = Date.at(year: targetDate.year, month: targetDate.month, day: targetDate.day, hour: 0, minute: 0, second: 0)
            let edDate = Date.at(year: targetDate.year, month: targetDate.month, day: targetDate.day, hour: 23, minute: 59, second: 59)
            
            var emotes: [EmotionEntity] = []
            if let results = realm?.objects(EmotionEntity.self).filter("emoteAt >= %@ AND emoteAt <= %@", stDate, edDate) {
                for result in results {
                    emotes.append(result)
                }
            }
            
            observer.onNext(emotes)
            return Disposables.create()
        }
    }
    
    // 指定期間の時間帯別エモーションデータ取得
    class func emotionsWithPeriodPerHours(period: EmotionPeriod) -> [EmotionCount] {
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
                switch result.emotion {
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
        
        return resultsPerHour
    }
    
    class func rx_emotionsWithPeriodPerHours(period: EmotionPeriod) -> Observable<[EmotionCount]> {
        return Observable.create { observer in
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
                _ = results.map { model in
                    switch(model.emotion) {
                    case Emotion.Happy.rawValue:
                        resultsPerHour[model.hour].happyCount += 1
                    case Emotion.Enjoy.rawValue:
                        resultsPerHour[model.hour].enjoyCount += 1
                    case Emotion.Sad.rawValue:
                        resultsPerHour[model.hour].sadCount += 1
                    case Emotion.Frustrated.rawValue:
                        resultsPerHour[model.hour].frustCount += 1
                    default:
                        break
                    }
                }
            }
            
            observer.onNext(resultsPerHour)
            
            return Disposables.create()
        }
    }
    
    // 曜日別エモーションデータ取得
    class func emotionWithWeek(period: EmotionPeriod) -> [EmotionCount] {
        var resultsWeekday: [EmotionCount] = []
        // 0で初期化
        for _ in 0...7 {
            resultsWeekday.append(EmotionCount())
        }
        
        var queryResult: Results<EmotionEntity>?
        if let filterStr = filterStringWithPeriod(period: period) {
            queryResult = realm?.objects(EmotionEntity.self).filter(filterStr)
        } else {
            queryResult = realm?.objects(EmotionEntity.self)
        }
        
        if let results = queryResult {
            _ = results.map { model in
                switch(model.emotion) {
                case Emotion.Happy.rawValue:
                    resultsWeekday[model.weekday].happyCount += 1
                case Emotion.Enjoy.rawValue:
                    resultsWeekday[model.weekday].enjoyCount += 1
                case Emotion.Sad.rawValue:
                    resultsWeekday[model.weekday].sadCount += 1
                case Emotion.Frustrated.rawValue:
                    resultsWeekday[model.weekday].frustCount += 1
                default:
                    break
                }
            }
        }
        
        return resultsWeekday
    }
    
    class func rx_emotionsWithWeek(period: EmotionPeriod) -> Observable<[EmotionCount]> {
        return Observable.create { observer in
            
            var resultsWeekday: [EmotionCount] = []
            // 0で初期化
            for _ in 0...7 {
                resultsWeekday.append(EmotionCount())
            }
            
            var queryResult: Results<EmotionEntity>?
            if let filterStr = filterStringWithPeriod(period: period) {
                queryResult = realm?.objects(EmotionEntity.self).filter(filterStr)
            } else {
                queryResult = realm?.objects(EmotionEntity.self)
            }
            
            if let results = queryResult {
                _ = results.map { model in
                    switch(model.emotion) {
                    case Emotion.Happy.rawValue:
                        resultsWeekday[model.weekday].happyCount += 1
                    case Emotion.Enjoy.rawValue:
                        resultsWeekday[model.weekday].enjoyCount += 1
                    case Emotion.Sad.rawValue:
                        resultsWeekday[model.weekday].sadCount += 1
                    case Emotion.Frustrated.rawValue:
                        resultsWeekday[model.weekday].frustCount += 1
                    default:
                        break
                    }
                }
            }
            observer.onNext(resultsWeekday)
            
            return Disposables.create()
        }
    }
    
    // 指定期間のエモーションデータ取得
    class func emotionsWithPeriod(period: EmotionPeriod) -> (EmotionCount) {
        var queryResult: Results<EmotionEntity>?
        
        if let predicate = filterStringWithPeriod(period: period) {
            queryResult = realm?.objects(EmotionEntity.self).filter(predicate)
        } else {
            queryResult = realm?.objects(EmotionEntity.self)
        }
        
        if let results = queryResult {
            let emoteCount = results.reduce(EmotionCount(),
                                            { count, result in
                                                
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
            return emoteCount
        }
        return EmotionCount()
    }
    
    class func rx_emotionsWithPeriod(period: EmotionPeriod) -> Observable<EmotionCount> {
        return Observable.create { observer in
            
            var queryResult: Results<EmotionEntity>?
            
            if let predicate = filterStringWithPeriod(period: period) {
                queryResult = realm?.objects(EmotionEntity.self).filter(predicate)
            } else {
                queryResult = realm?.objects(EmotionEntity.self)
            }
            
            if let results = queryResult {
                let emoteCount = results.reduce(EmotionCount(),
                                                { count, result in
                                                    
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
                observer.onNext(emoteCount)
            }
            
            return Disposables.create()
        }
    }
    
    private class func filterStringWithPeriod(period: EmotionPeriod) -> NSPredicate? {
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
    class func storeEmotion(emotion: Emotion) {
        let emoteObject = EmotionEntity()
        emoteObject.emoteAt = Date()
        emoteObject.emotion = emotion.rawValue
        emoteObject.hour    = emoteObject.emoteAt.hour
        emoteObject.weekday = emoteObject.emoteAt.weekday
        
        try! realm?.write {
            realm?.add(emoteObject)
        }
    }
    
    // MARK: -- Delete
    class func clearAll() {
        try! realm?.write {
            realm?.deleteAll()
        }
    }
}

//
//  EmotionDataStore.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/08/12.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol EmotionDataStore: class {
    static var sharedInstance: EmotionDataStore { get }
    // 指定日付のエモーションデータ取得
    func emotionsWithDate(targetDate: Date, completion: ([EmotionEntity])->())
    // 指定期間の時間帯別エモーションデータ取得
    func emotionsWithPeriodPerHours(period: EmotionPeriod, completion: ([EmotionCount])->())
    // 曜日別エモーションデータ取得
    func emotionsWithWeek(period: EmotionPeriod, completion: ([EmotionCount])->())
    // 指定期間のエモーションデータ取得
    func emotionsWithPeriod(period: EmotionPeriod, completion: (EmotionCount)->())
    // エモーション保存
    func storeEmotion(emotion: Emotion, emoteAt: Date?)
    // MARK: -- Delete
    func clearAll()
}

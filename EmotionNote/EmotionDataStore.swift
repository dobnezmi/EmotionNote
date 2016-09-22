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
    func rx_emotionsWithDate(targetDate: Date) -> Observable<[EmotionEntity]>
    // 指定期間の時間帯別エモーションデータ取得
    func rx_emotionsWithPeriodPerHours(period: EmotionPeriod) -> Observable<[EmotionCount]>
    // 曜日別エモーションデータ取得
    func rx_emotionsWithWeek(period: EmotionPeriod) -> Observable<[EmotionCount]>
    // 指定期間のエモーションデータ取得
    func rx_emotionsWithPeriod(period: EmotionPeriod) -> Observable<EmotionCount>
    // エモーション保存
    func storeEmotion(emotion: Emotion)
    // MARK: -- Delete
    func clearAll()
}

//
//  EmotionEntityTest.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/08/12.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import EmotionNote

class EmotionEntityTest: QuickSpec {
    
    override func spec() {
        beforeSuite() {
            EmotionDataStore.clearAll()
        }
        
        describe("感情を保存して取得できること") {
            context("データがないとき") {
                it("データがなければ空で返る") {
                    expect(EmotionDataStore.emotionsWithDate(Date()).count).to(equal(0))
                    
                    let results = EmotionDataStore.emotionsWithPeriodPerHours(.All)
                    expect(results.count).to(equal(24))
                    expect(results[0].happyCount).to(equal(0))
                    expect(results[0].enjoyCount).to(equal(0))
                    expect(results[0].sadCount).to(equal(0))
                    expect(results[0].frustCount).to(equal(0))
                    expect(results[23].happyCount).to(equal(0))
                    expect(results[23].enjoyCount).to(equal(0))
                    expect(results[23].sadCount).to(equal(0))
                    expect(results[23].frustCount).to(equal(0))
                    
                    let emotion = EmotionDataStore.emotionsWithPeriod(.All)
                    expect(emotion.happyCount).to(equal(0))
                    expect(emotion.enjoyCount).to(equal(0))
                    expect(emotion.sadCount).to(equal(0))
                    expect(emotion.frustCount).to(equal(0))
                }
            
                it("１件保存すれば１件増えて返る") {
                    EmotionDataStore.storeEmotion(.Enjoy)
                    
                    expect(EmotionDataStore.emotionsWithDate(Date()).count).to(equal(1))
                    
                    let emotion = EmotionDataStore.emotionsWithPeriod(.All)
                    expect(emotion.happyCount).to(equal(0))
                    expect(emotion.enjoyCount).to(equal(1))
                    expect(emotion.sadCount).to(equal(0))
                    expect(emotion.frustCount).to(equal(0))
                }
            }
            
            context("データがあるとき") {
                beforeEach {
                    EmotionDataStore.clearAll()
                    EmotionDataStore.storeEmotion(.Enjoy)
                    EmotionDataStore.storeEmotion(.Happy)
                    EmotionDataStore.storeEmotion(.Sad)
                    EmotionDataStore.storeEmotion(.Frustrated)
                }
                
                it("指定日付のデータが取得できること") {
                    let results = EmotionDataStore.emotionsWithDate(Date())
                    expect(results.count).to(equal(4))
                    
                    let oldDate = Date(year: 2016, month: 8, day: 1, hour: 0, minute: 0, second: 0)
                    let oldResults = EmotionDataStore.emotionsWithDate(oldDate)
                    expect(oldResults.count).to(equal(0))
                }
                
                it("指定期間のデータが取得できること") {
                    let results = EmotionDataStore.emotionsWithPeriodPerHours(.All)
                    expect(results.count).to(equal(24))
                    
                    let currentDate = Date()
                    expect(results[currentDate.hour].enjoyCount).to(equal(1))
                    expect(results[currentDate.hour].happyCount).to(equal(1))
                    expect(results[currentDate.hour].sadCount).to(equal(1))
                    expect(results[currentDate.hour].frustCount).to(equal(1))
                }
                
                it("指定曜日のデータが取得できること") {
                    let results = EmotionDataStore.emotionWithWeek(.All)
                    expect(results.count).to(equal(8)) // 1開始で7曜日。0は空データ
                    
                    let currentDate = Date()
                    expect(results[currentDate.weekday].enjoyCount).to(equal(1))
                    expect(results[currentDate.weekday].happyCount).to(equal(1))
                    expect(results[currentDate.weekday].sadCount).to(equal(1))
                    expect(results[currentDate.weekday].frustCount).to(equal(1))
                }
                
                it("感情の統計を取得できること") {
                    let results = EmotionDataStore.emotionsWithPeriod(.All)
                    expect(results.happyCount).to(equal(1))
                    expect(results.enjoyCount).to(equal(1))
                    expect(results.sadCount).to(equal(1))
                    expect(results.frustCount).to(equal(1))
                }
            }
            
        }
    }
    
}

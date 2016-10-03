//
//  ChartTestCase.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/22.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import XCTest
import Swinject
import RxSwift
import Quick
import Nimble
@testable import EmotionNote

class ChartTestCase: QuickSpec {
    let dataStore: EmotionDataStoreRealm = EmotionDataStoreRealm()
    let disposeBag = DisposeBag()
    
    override func spec() {
        beforeEach {
            Injector.initialize()
            Injector.setupTest()
            self.dataStore.clearAll()
            
            try! self.dataStore.realm?.write {
                let emoteObject = EmotionEntity()
                emoteObject.emoteAt = Date().add(days: -1)
                emoteObject.emotion = Emotion.Enjoy.rawValue
                emoteObject.hour    = 1
                emoteObject.weekday = 1
                self.dataStore.realm?.add(emoteObject)
                
                let emoteObject2 = EmotionEntity()
                emoteObject2.emoteAt = Date().add(days: -2)
                emoteObject2.emotion = Emotion.Enjoy.rawValue
                emoteObject2.hour    = 2
                emoteObject2.weekday = 1
                self.dataStore.realm?.add(emoteObject2)
                
                let emoteObject3 = EmotionEntity()
                emoteObject3.emoteAt = Date().add(week: -1)
                emoteObject3.emotion = Emotion.Enjoy.rawValue
                emoteObject3.hour    = 2
                emoteObject3.weekday = 2
                self.dataStore.realm?.add(emoteObject3)
                
                let emoteObject4 = EmotionEntity()
                emoteObject4.emoteAt = Date().add(month: -1).add(days: -1)
                emoteObject4.emotion = Emotion.Enjoy.rawValue
                emoteObject4.hour    = 2
                emoteObject4.weekday = 1
                self.dataStore.realm?.add(emoteObject4)
            }
        }
        
        describe("Fetch data") {
            it("Emotions with date") {
                var count1 = -1
                var count2 = -1
                
                self.dataStore.emotionsWithDate(targetDate: Date().add(days: -1)) { emotions in
                    count1 = emotions.count
                }
                self.dataStore.emotionsWithDate(targetDate: Date()) { emotions in
                    count2 = emotions.count
                }
                expect(count1).toEventually(equal(1))
                expect(count2).toEventually(equal(0))
            }
            
            it("Emotions with period") {
                var count1 = 0
                var count2 = 0
                var count3 = 0
                self.dataStore.emotionsWithPeriod(period: .Week) { emotions in
                    count1 = emotions.enjoyCount
                }
                self.dataStore.emotionsWithPeriod(period: .Month) { emotions in
                    count2 = emotions.enjoyCount
                }
                self.dataStore.emotionsWithPeriod(period: .All) { emotions in
                    count3 = emotions.enjoyCount
                }
                expect(count1).toEventually(equal(2))
                expect(count2).toEventually(equal(3))
                expect(count3).toEventually(equal(4))
            }
            
            it("Emotions with week") {
                var sunCount1 = -1
                var monCount1 = -1
                var tueCount1 = -1
                self.dataStore.emotionsWithWeek(period: .All) { emotions in
                    sunCount1 = emotions[0].enjoyCount
                    monCount1 = emotions[1].enjoyCount
                    tueCount1 = emotions[2].enjoyCount
                }
                expect(sunCount1).toEventually(equal(0))
                expect(monCount1).toEventually(equal(3))
                expect(tueCount1).toEventually(equal(1))
                
                var sunCount2 = -1
                var monCount2 = -1
                var tueCount2 = -1
                self.dataStore.emotionsWithPeriodPerHours(period: .All) { emotions in
                    sunCount2 = emotions[0].enjoyCount
                    monCount2 = emotions[1].enjoyCount
                    tueCount2 = emotions[2].enjoyCount
                }
                expect(sunCount2).toEventually(equal(0))
                expect(monCount2).toEventually(equal(1))
                expect(tueCount2).toEventually(equal(3))
            }
            
            
        }
    }
    
    override func setUp() {
        super.setUp()
        Injector.initialize()
        Injector.setupTest()
        
        try! dataStore.realm?.write {
            let emoteObject = EmotionEntity()
            emoteObject.emoteAt = Date().add(days: -1)
            emoteObject.emotion = Emotion.Enjoy.rawValue
            emoteObject.hour    = 1
            emoteObject.weekday = 1
            dataStore.realm?.add(emoteObject)
        
            let emoteObject2 = EmotionEntity()
            emoteObject2.emoteAt = Date().add(days: -2)
            emoteObject2.emotion = Emotion.Enjoy.rawValue
            emoteObject2.hour    = 2
            emoteObject2.weekday = 1
            dataStore.realm?.add(emoteObject2)
        
            let emoteObject3 = EmotionEntity()
            emoteObject3.emoteAt = Date().add(week: -1)
            emoteObject3.emotion = Emotion.Enjoy.rawValue
            emoteObject3.hour    = 2
            emoteObject3.weekday = 2
            dataStore.realm?.add(emoteObject3)
        
            let emoteObject4 = EmotionEntity()
            emoteObject4.emoteAt = Date().add(month: -1).add(days: -1)
            emoteObject4.emotion = Emotion.Enjoy.rawValue
            emoteObject4.hour    = 2
            emoteObject4.weekday = 1
            dataStore.realm?.add(emoteObject4)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        dataStore.clearAll()
    }
    
    func testFetchData() {
        var expectations: [XCTestExpectation] = []
        for _ in 1...7 {
            expectations.append(self.expectation(description: "DataStore test"))
        }
        
        dataStore.emotionsWithDate(targetDate: Date().add(days: -1)) { emotions in
            XCTAssertEqual(emotions.count, 1)
            expectations[0].fulfill()
        }
        dataStore.emotionsWithDate(targetDate: Date()) { emotions in
            XCTAssertEqual(emotions.count, 0)
            expectations[1].fulfill()
        }
        dataStore.emotionsWithPeriod(period: .Week) { emotions in
            XCTAssertEqual(emotions.enjoyCount, 2)
            expectations[2].fulfill()
        }
        dataStore.emotionsWithPeriod(period: .Month) { emotions in
            XCTAssertEqual(emotions.enjoyCount, 3)
            expectations[3].fulfill()
        }
        dataStore.emotionsWithPeriod(period: .All) { emotions in
            XCTAssertEqual(emotions.enjoyCount, 4)
            expectations[4].fulfill()
        }
        dataStore.emotionsWithWeek(period: .All) { emotions in
            XCTAssertEqual(emotions[0].enjoyCount, 0)
            XCTAssertEqual(emotions[1].enjoyCount, 3)
            XCTAssertEqual(emotions[2].enjoyCount, 1)
            expectations[5].fulfill()
        }
        dataStore.emotionsWithPeriodPerHours(period: .All) { emotions in
            XCTAssertEqual(emotions[0].enjoyCount, 0)
            XCTAssertEqual(emotions[1].enjoyCount, 1)
            XCTAssertEqual(emotions[2].enjoyCount, 3)
            expectations[6].fulfill()
        }

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}

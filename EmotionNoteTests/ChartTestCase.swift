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
@testable import EmotionNote

class ChartTestCase: XCTestCase {
    let dataStore: EmotionDataStoreRealm = EmotionDataStoreRealm()
    let disposeBag = DisposeBag()
    
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

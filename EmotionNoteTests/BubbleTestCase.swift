//
//  BubbleTestCase.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/22.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import XCTest
import RxSwift
import Swinject
@testable import EmotionNote

class BubbleTestCase: XCTestCase {
    var dataStore: EmotionDataStore!
    
    override func setUp() {
        super.setUp()
        Injector.initialize()
        Injector.setupTest()
        dataStore = Injector.container.resolve(EmotionDataStore.self)!
    }
    
    override func tearDown() {
        super.tearDown()
        dataStore.clearAll()
    }
    
    func testSelectEmote() {
        let presenter: BubbleViewPresenter = Injector.container.resolve(BubbleViewPresenter.self)!
        let expectation = self.expectation(description: "stored expectation")

        presenter.didSelectAtIndex(1)
        dataStore.emotionsWithDate(targetDate: Date(), completion: { emotions in
            XCTAssertEqual(emotions.count, 1)
            XCTAssertEqual(emotions[0].emotion, presenter.rx_emotions.value[1].rawValue)
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 0.5, handler: nil)
    }
}

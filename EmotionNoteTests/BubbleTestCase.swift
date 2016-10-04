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
import Quick
import Nimble
@testable import EmotionNote

class BubbleTestCase: QuickSpec {
    var dataStore: EmotionDataStore!
    
    override func spec() {
        beforeEach {
            self.dataStore = Injector.container.resolve(EmotionDataStore.self)!
            self.dataStore.clearAll()
            Injector.initialize()
            Injector.setupTest()
        }
        
        afterEach {
            self.dataStore.clearAll()
        }
        
        describe("Select emotion") {
            it("stored emote information") {
                let presenter: BubbleViewPresenter = Injector.container.resolve(BubbleViewPresenter.self)!
                presenter.didSelectAtIndex(1)
                
                var count = 0
                var emotion = 0
                self.dataStore.emotionsWithDate(targetDate: Date(), completion: { emotions in
                    count = emotions.count
                    emotion = emotions[0].emotion
                })
                expect(count).toEventually(equal(1))
                expect(emotion).toEventually(equal(Emotion.Enjoy.rawValue))
            }
        }
    }
}

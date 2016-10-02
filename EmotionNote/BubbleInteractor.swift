//
//  BubbleInteractor.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation

protocol BubbleInteractor: class {
    func storeEmotion(emotion: Emotion)
}

final class BubbleInteractorImpl: BubbleInteractor {
    let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!
    
    func storeEmotion(emotion: Emotion) {
        dataStore.storeEmotion(emotion: emotion)
    }
}

//
//  BubbleInteractor.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation

protocol BubbleInteractor: class {
    func storeEmotion(emotion: Emotion)
}

final class BubbleInteractorImpl: BubbleInteractor {
    func storeEmotion(emotion: Emotion) {
        EmotionDataStore.storeEmotion(emotion)
    }
}
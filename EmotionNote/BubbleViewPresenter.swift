//
//  BubbleViewPresenter.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/20.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

protocol BubbleViewPresenter: class {
    var rx_emotions: Variable<[Emotion]> { get }
    func didSelectAtIndex(_ index: Int)
    func resetEmotions()
}

final class BubbleViewPresenterImpl: BubbleViewPresenter {
    let rx_emotions: Variable<[Emotion]> = Variable([])
    var interactor: BubbleInteractor? = Injector.container.resolve(BubbleInteractor.self)
    
    init() {
        resetEmotions()
    }
    
    func didSelectAtIndex(_ index: Int) {
        interactor?.storeEmotion(emotion: rx_emotions.value[index])
    }
    
    func resetEmotions() {
        let emotions: [Emotion] = [.Happy, .Enjoy, .Sad, .Frustrated]
        rx_emotions.value.removeAll()
        for emotion in emotions {
            rx_emotions.value.append(emotion)
        }
    }
}

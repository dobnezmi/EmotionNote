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
    func didSelectAtIndex(index: Int)
}

final class BubbleViewPresenterImpl: BubbleViewPresenter {
    let rx_emotions: Variable<[Emotion]> = Variable([])
    var interactor: BubbleInteractor? = Injector.container.resolve(BubbleInteractor.self)
    
    init() {
        let emotions: [Emotion] = [.Happy, .Enjoy, .Sad, .Frustrated]
        for emotion in emotions {
            rx_emotions.value.append(emotion)
        }
    }
    
    func didSelectAtIndex(index: Int) {
        interactor?.storeEmotion(rx_emotions.value[index])
    }
}

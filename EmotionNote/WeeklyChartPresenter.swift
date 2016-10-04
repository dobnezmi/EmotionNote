//
//  WeeklyChartPresenter.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/10/02.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift


protocol WeeklyChartPresenter: class {
    var rx_weeklyEmotion: Variable<[EmotionCount]> { get }
}

final class WeeklyChartPresenterImpl: WeeklyChartPresenter {
    let interactor: WeeklyChartInteractor = Injector.container.resolve(WeeklyChartInteractor.self)!
    let rx_weeklyEmotion: Variable<[EmotionCount]> = Variable([])
    
    let disposeBag = DisposeBag()
    
    init() {
        bindObject()
    }
    
    private func bindObject() {
        interactor.rx_weekyEmotions(period: .All).subscribe(onNext: { [weak self] emotionCount in
            self?.rx_weeklyEmotion.value = emotionCount
        }).addDisposableTo(disposeBag)
    }
}

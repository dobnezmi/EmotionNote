//
//  MentalStatisticsPresenter.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/19.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

protocol MentalStatisticsPresenter: class {
    var rx_weeklyEmotion: Variable<EmotionCount?> { get }
    var rx_monthlyEmotion: Variable<EmotionCount?> { get }
    var rx_entireEmotion: Variable<EmotionCount?> { get }
}

final class MentalStatisticsPresenterImpl: MentalStatisticsPresenter {
    let interactor: MentalStatisticsInteractor = Injector.container.resolve(MentalStatisticsInteractor.self)!
    let rx_weeklyEmotion: Variable<EmotionCount?> = Variable(nil)
    let rx_monthlyEmotion: Variable<EmotionCount?> = Variable(nil)
    let rx_entireEmotion: Variable<EmotionCount?> = Variable(nil)
    
    let disposeBag = DisposeBag()
    
    init() {
        bindObject()
    }
    
    private func bindObject() {
        interactor.rx_emotionsWithPeriod(period: .Week).subscribe(onNext: { [weak self] emotionCount in
            self?.rx_weeklyEmotion.value = emotionCount
        }).addDisposableTo(disposeBag)
        
        interactor.rx_emotionsWithPeriod(period: .Month).subscribe(onNext: { [weak self] emotionCount in
            self?.rx_monthlyEmotion.value = emotionCount
        }).addDisposableTo(disposeBag)
        
        interactor.rx_emotionsWithPeriod(period: .All).subscribe(onNext: { [weak self] emotionCount in
            self?.rx_entireEmotion.value = emotionCount
        }).addDisposableTo(disposeBag)
    }
}

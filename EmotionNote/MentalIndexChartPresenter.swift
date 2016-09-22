//
//  MentalIndexChartPresenter.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/18.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

protocol MentalIndexChartPresenter: class {
    var rx_todayEmotions: Variable<[EmotionEntity]> { get }
    var rx_yesterdayEmotins: Variable<[EmotionEntity]> { get }
    var rx_oldEmotions: Variable<[EmotionEntity]> { get }
}

final class MentalIndexChartPresenterImpl: MentalIndexChartPresenter {
    let interactor: MentalIndexChartInteractor = Injector.container.resolve(MentalIndexChartInteractor.self)!
    let disposeBag = DisposeBag()
    
    let rx_todayEmotions: Variable<[EmotionEntity]> = Variable([])
    let rx_yesterdayEmotins: Variable<[EmotionEntity]> = Variable([])
    let rx_oldEmotions: Variable<[EmotionEntity]> = Variable([])
    
    init() {
        bindObject()
    }
    
    func bindObject() {
        interactor.rx_emotionsWithDate(targetDate: Date()).subscribe(onNext: { [weak self] emotions in
            self?.rx_todayEmotions.value = emotions
        }).addDisposableTo(disposeBag)
        interactor.rx_emotionsWithDate(targetDate: Date().add(days: -1)).subscribe(onNext: { [weak self] emotions in
            self?.rx_yesterdayEmotins.value = emotions
        }).addDisposableTo(disposeBag)
        interactor.rx_emotionsWithDate(targetDate: Date().add(days: -2)).subscribe(onNext: { [ weak self] emotions in
            self?.rx_oldEmotions.value = emotions
        }).addDisposableTo(disposeBag)
    }
}

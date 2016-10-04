//
//  HourlyChartPresenter.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/19.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

protocol HourlyChartPresenter: class {
    var rx_happyEmotion: Variable<[Int]> { get }
    var rx_enjoyEmotin: Variable<[Int]> { get }
    var rx_sadEmotion: Variable<[Int]> { get }
    var rx_frustEmotion: Variable<[Int]> { get }
}

final class HourlyChartPresenterImpl: HourlyChartPresenter {
    let interactor: HourlyChartInteractor = Injector.container.resolve(HourlyChartInteractor.self)!
    let rx_happyEmotion: Variable<[Int]> = Variable([])
    let rx_enjoyEmotin: Variable<[Int]> = Variable([])
    let rx_sadEmotion: Variable<[Int]> = Variable([])
    let rx_frustEmotion: Variable<[Int]> = Variable([])
    
    let disposeBag = DisposeBag()
    
    init() {
        bindObject()
    }
    
    private func bindObject() {
        interactor.rx_emotionsWithPeriodPerHours(period: .All).subscribe(onNext: { [weak self] emotions in
            var happyCount: [Int] = []
            var enjoyCount: [Int] = []
            var sadCount: [Int] = []
            var frustCount: [Int] = []
            
            for emotion in emotions {
                happyCount.append(emotion.happyCount)
                enjoyCount.append(emotion.enjoyCount)
                sadCount.append(emotion.sadCount)
                frustCount.append(emotion.frustCount)
            }
            self?.rx_happyEmotion.value = happyCount
            self?.rx_enjoyEmotin.value = enjoyCount
            self?.rx_sadEmotion.value = sadCount
            self?.rx_frustEmotion.value = frustCount
        }).addDisposableTo(disposeBag)
    }
}

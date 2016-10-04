//
//  HourlyChartInteractor.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/19.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RxSwift

protocol HourlyChartInteractor: class {
    func rx_emotionsWithPeriodPerHours(period: EmotionPeriod) -> Observable<[EmotionCount]> 
}

final class HourlyChartInteractorImpl: HourlyChartInteractor {
    let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!
    
    func rx_emotionsWithPeriodPerHours(period: EmotionPeriod) -> Observable<[EmotionCount]> {
        return Observable.create { [weak self] observer in
            self?.dataStore.emotionsWithPeriodPerHours(period: period, completion: { emotionCount in
                observer.onNext(emotionCount)
            })
            return Disposables.create()
        }
    }
}

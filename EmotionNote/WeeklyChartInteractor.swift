//
//  WeeklyChartInteractor.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/10/01.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RxSwift

protocol WeeklyChartInteractor: class {
    func rx_weekyEmotions(period: EmotionPeriod) -> Observable<[EmotionCount]>
}

final class WeeklyChartInteractorImpl: WeeklyChartInteractor {
    let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!
    
    func rx_weekyEmotions(period: EmotionPeriod) -> Observable<[EmotionCount]> {
        return Observable.create { [weak self] observer in
            self?.dataStore.emotionsWithWeek(period: period, completion: { emotionCount in
                observer.onNext(emotionCount)
            })
            return Disposables.create()
        }
    }
}

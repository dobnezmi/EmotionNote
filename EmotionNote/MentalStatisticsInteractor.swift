//
//  MentalStatisticsInteractor.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/19.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RxSwift

protocol MentalStatisticsInteractor: class {
    func rx_emotionsWithPeriod(period: EmotionPeriod) -> Observable<EmotionCount>
}

final class MentalStatisticsInteractorImpl: MentalStatisticsInteractor {
    let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!
    
    func rx_emotionsWithPeriod(period: EmotionPeriod) -> Observable<EmotionCount> {
        return Observable.create { [weak self] observer in
            self?.dataStore.emotionsWithPeriod(period: period, completion: { emotionCount in
                observer.onNext(emotionCount)
            })
            return Disposables.create()
        }
    }
}

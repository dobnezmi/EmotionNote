//
//  HourlyChartInteractor.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/19.
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
        return dataStore.rx_emotionsWithPeriodPerHours(period: period)
    }
}

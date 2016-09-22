//
//  MentalIndexChartInteractor.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/18.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RxSwift

protocol MentalIndexChartInteractor: class {
    func rx_emotionsWithDate(targetDate: Date) -> Observable<[EmotionEntity]>
}

final class MentalIndexChartInteractorImpl: MentalIndexChartInteractor {
    let dataStore = Injector.container.resolve(EmotionDataStore.self)!
    
    func rx_emotionsWithDate(targetDate: Date) -> Observable<[EmotionEntity]> {
        return dataStore.rx_emotionsWithDate(targetDate: targetDate)
    }
}

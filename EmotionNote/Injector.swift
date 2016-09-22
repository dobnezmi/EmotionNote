//
//  Injector.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import Swinject

final class Injector {
    static let container = Container()
    
    class func initialize() {
        container.register(BubbleInteractor.self) { _ in
            BubbleInteractorImpl()
        }
        container.register(EmotionDataStore.self) { _ in
            EmotionDataStoreRealm()
        }
        container.register(MentalIndexChartInteractor.self) { _ in
            MentalIndexChartInteractorImpl()
        }
        container.register(MentalIndexChartPresenter.self) { _ in
            MentalIndexChartPresenterImpl()
        }
        container.register(HourlyChartInteractor.self) { _ in
            HourlyChartInteractorImpl()
        }
        container.register(HourlyChartPresenter.self) { _ in
            HourlyChartPresenterImpl()
        }
        container.register(MentalStatisticsInteractor.self) { _ in
            MentalStatisticsInteractorImpl()
        }
        container.register(MentalStatisticsPresenter.self) { _ in
            MentalStatisticsPresenterImpl()
        }
    }
    
    class func setupTest() {
        Injector.container.register(MentalIndexChartPresenter.self) { _ in
            MentalIndexChartPresenterImpl()
        }
        Injector.container.register(HourlyChartPresenter.self) { _ in
            HourlyChartPresenterImpl()
        }
        Injector.container.register(MentalStatisticsPresenter.self) { _ in
            MentalStatisticsPresenterImpl()
        }
        Injector.container.register(BubbleViewPresenter.self) { _ in
            BubbleViewPresenterImpl()
        }
    }
}

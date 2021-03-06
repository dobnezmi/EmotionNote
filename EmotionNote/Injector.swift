//
//  Injector.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/15.
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
            EmotionDataStoreRealm.sharedInstance
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
        container.register(WeeklyChartInteractor.self) { _ in
            WeeklyChartInteractorImpl()
        }
        container.register(WeeklyChartPresenter.self) { _ in
            WeeklyChartPresenterImpl()
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

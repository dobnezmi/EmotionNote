//
//  DailyChartViewRouter.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/24.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

protocol DailyChartViewRouter {
    func closeAction(viewController: UIViewController?)
}

final class DailyChartViewWireframe: DailyChartViewRouter {
    func closeAction(viewController: UIViewController?) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

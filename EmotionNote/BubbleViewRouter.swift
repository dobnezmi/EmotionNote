//
//  BubbleViewRouter.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

protocol BubbleViewRouter: class {
    func nextScreen(viewController: UIViewController?)
}

final class BubbleViewRouterImpl: BubbleViewRouter {
    func nextScreen(viewController: UIViewController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DailyChartViewController")
        vc.transitioningDelegate = vc as? UIViewControllerTransitioningDelegate
        viewController?.present(vc, animated: true, completion: nil)
    }
}

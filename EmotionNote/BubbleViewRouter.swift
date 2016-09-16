//
//  BubbleViewRouter.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

protocol BubbleViewRouter: class {
    func nextScreen(viewController: UIViewController?, transition: UIViewControllerTransitioningDelegate?)
}

final class BubbleViewRouterImpl: BubbleViewRouter {
    func nextScreen(viewController: UIViewController?, transition: UIViewControllerTransitioningDelegate?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DailyChartViewController")
        vc.transitioningDelegate = transition
        viewController?.presentViewController(vc, animated: true, completion: nil)
    }
}

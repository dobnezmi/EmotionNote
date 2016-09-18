//
//  FadeTransition.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/11.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        toView?.alpha = 0.0
        container.addSubview(toView!)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toView?.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

}

//
//  FadeTransition.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/11.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        toView?.alpha = 0.0
        container?.addSubview(toView!)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            toView?.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

}

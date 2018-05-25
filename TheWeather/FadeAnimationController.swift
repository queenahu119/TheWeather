//
//  FadeAnimationController.swift
//  TheWeather
//
//  Created by QueenaHuang on 22/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

class FadeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private var presenting: Bool

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let container = transitionContext.containerView

        if (presenting) {
            container.addSubview(toView)
            toView.alpha = 0.0

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            container.insertSubview(toView, belowSubview: fromView)

            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    init(presenting: Bool) {
        self.presenting = presenting
    }

}

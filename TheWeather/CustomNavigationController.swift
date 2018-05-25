//
//  CustomNavigationController.swift
//  TheWeather
//
//  Created by QueenaHuang on 24/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    private var interactionController: UIPercentDrivenInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        setupBackGesture()
    }

    private func setupBackGesture() {
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                          action: #selector(self.handleEdgePan(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
    }

    @objc func handleEdgePan(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {

        let translate = gestureRecognizer.translation(in: gestureRecognizer.view)
        let percent = translate.x / gestureRecognizer.view!.bounds.size.width

        if gestureRecognizer.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .push {
            return FadeAnimationController(presenting: true)
        } else {
            return FadeAnimationController(presenting: false)
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

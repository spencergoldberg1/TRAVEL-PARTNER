//
//  TransitionController.swift
//  
//
//  Created by Spencer Goldberg on 7/1/22.
//

import UIKit

class ToastAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
           
        let containerView = transitionContext.containerView
        let topSafeAreaInset = containerView.safeAreaInsets.top
        
        containerView.addSubview(toVC.view)
        
        toVC.view.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.90, height: 49)
        
        containerView.frame = toVC.view.frame
        // Move the toast offscreen initially
        containerView.frame.origin.y = -49
        containerView.center.x = UIScreen.main.bounds.midX
        
        
        toVC.view.backgroundColor = .clear
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       animations: {
                        containerView.transform = CGAffineTransform(translationX: 0, y: 52 + topSafeAreaInset)
                       },
                       completion: { completed in
                        transitionContext.completeTransition(true)
                       })
    }
    
    
}

class ToastDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let containerView = transitionContext.containerView
        let topSafeAreaInset = containerView.safeAreaInsets.top
        
        toVC.view.backgroundColor = .clear
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       animations: {
                        containerView.transform = CGAffineTransform(translationX: 0, y: -(50 + topSafeAreaInset))
                       },
                       completion: { completed in
                        transitionContext.completeTransition(true)
                       })
    }
    
    
}

class ToastTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    private let transition = ToastAnimationController()
    private let dismissTransition = ToastDismissAnimation()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}


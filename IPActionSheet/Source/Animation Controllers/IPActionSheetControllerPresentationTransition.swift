//
//  IPActionSheetControllerPresentationTransition.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

final class IPActionSheetControllerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? IPActionSheetController else {
            
            return
        }
        
        let containerView = transitionContext.containerView
        
        toVC.loadViewIfNeeded()
        toVC.view.layoutIfNeeded()
        containerView.addSubview(toVC.view)
        let effect = toVC.visualEffectView.effect
        toVC.visualEffectView.effect = nil
        let cardFrame = toVC.containerView.frame
        toVC.containerView.alpha = 0
        let finalFrame = CGRect(x: cardFrame.origin.x,
                                y: cardFrame.origin.y - toVC.view.safeAreaInsets.bottom,
                                width: cardFrame.size.width,
                                height: cardFrame.size.height)
        toVC.containerView.frame = CGRect(x: cardFrame.origin.x, 
                                          y: transitionContext.containerView.frame.height,
                                          width: cardFrame.size.width,
                                          height: cardFrame.size.height)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveLinear,
                       animations:{ toVC.containerView.frame = finalFrame },
                       completion: nil)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: { toVC.visualEffectView.effect = effect })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/3, animations: { toVC.containerView.alpha = 1 })
        }, completion: { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

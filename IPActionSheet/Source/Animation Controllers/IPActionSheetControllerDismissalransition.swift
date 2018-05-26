//
//  IPActionSheetControllerDismissalransition.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

final class IPActionSheetControllerDismissalransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? IPActionSheetController else {
            
            return
        }

        let cardFrame = fromVC.containerView.frame
        let finalFrame = CGRect(x: cardFrame.origin.x,
                                y: transitionContext.containerView.frame.size.height,
                                width: cardFrame.size.width,
                                height: cardFrame.size.height)
        
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveLinear,
                           animations:{ fromVC.containerView.frame = finalFrame },
                           completion: nil)
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                fromVC.visualEffectView.effect = nil
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1, animations: { fromVC.containerView.alpha = 0 })
        }, completion: { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

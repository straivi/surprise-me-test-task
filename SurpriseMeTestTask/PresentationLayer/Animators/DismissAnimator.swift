//
//  DismissAnimator.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 19.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {
  
}

extension DismissAnimator: UIViewControllerAnimatedTransitioning{
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
    else { return }
    
    let containerView = transitionContext.containerView
    
    containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
    
    let screenBounds = UIScreen.main.bounds
    let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
    let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
    
//    UIView.animate(withDuration: transitionDuration(using: transitionContext), option: [.curveEaseIn], animations: {
//      fromVC.view.frame = finalFrame
//    }) { (_) in
//      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    }
    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseIn], animations: {
         fromVC.view.frame = finalFrame
       }) { (_) in
         transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
       }
  }
}

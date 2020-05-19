//
//  PresentAnimator.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 19.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class PresentAnimator: NSObject {
}

extension PresentAnimator: UIViewControllerAnimatedTransitioning{
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
    else { return }
    
    let containerView = transitionContext.containerView
    
    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
    
    let screenBounds = UIScreen.main.bounds
    
    let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
    let startFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
    
    let topLeftCorner = CGPoint(x: 0, y: 0)
    let finalFrame = CGRect(origin: topLeftCorner, size: screenBounds.size)
    
    
    let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) ?? UIView()
    containerView.insertSubview(snapshot, belowSubview: toVC.view)
    toVC.view.frame = startFrame
      
//    UIView.animate(withDuration: transitionDuration, option: [], (using: transitionContext), animations: {
//      toVC.view.frame = finalFrame
//    }) { (_) in
//      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    }
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut], animations: {
      toVC.view.frame = finalFrame
    }) { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
  }
}

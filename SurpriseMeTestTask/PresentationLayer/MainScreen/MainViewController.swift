//
//  MainViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 19.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  var interactor: Interactor? = nil
  
  //UI
  @IBOutlet weak var pullLabelView: UIView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var greetingLabel: UILabel!
  @IBOutlet weak var sininTextLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    setupPullLabel()
  }
  
  //Setup UI
  func setupPullLabel(){
    pullLabelView.layer.cornerRadius = pullLabelView.frame.height / 2
  }
  func setupTrackNameLabel(){
    trackNameLabel.text = """
    Sagrada Familia:
    Fast-Track and Audio Tour
    """
  }
  
  @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
    
    let percentThreshold: CGFloat = 0.3
    
    let translation = sender.translation(in: view)
    let verticalMovement = translation.y / view.bounds.height
    let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
    let downwardMovementPercent = fminf(downwardMovement, 1.0)
    let progress = CGFloat(downwardMovementPercent)
    
    guard let interactor = interactor else { return }
    
    switch sender.state {
    case .began:
      interactor.hasStarted = true
      dismiss(animated: true, completion: nil)
    case .changed:
      interactor.shouldFinish = progress > percentThreshold
      interactor.update(progress)
    case .cancelled:
      interactor.hasStarted = false
      interactor.cancel()
    case .ended:
      interactor.hasStarted = false
      interactor.shouldFinish ? interactor.finish(): interactor.cancel()
    default:
      break
    }
  }
}

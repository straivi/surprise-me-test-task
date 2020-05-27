//
//  ViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 18.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  //UI
  @IBOutlet weak var openModalButtonView: UIButton!
  
  //Dependencies
  let dismissAnimator = DismissAnimator()
  let presentAnimator = PresentAnimator()
  let interactor = Interactor()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillLayoutSubviews() {
        setupOpenModelButton()
  }
  

  @IBAction func openModalButtonTapped(_ sender: UIButton) {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let singin = sb.instantiateViewController(withIdentifier: String(describing: MainViewController.self))
    let sininVC = singin as! MainViewController
    
    sininVC.interactor = interactor
    sininVC.transitioningDelegate = self
    present(sininVC, animated: true, completion: nil)
  }
  
  
  //UI setup
  func setupOpenModelButton(){
    let buttonColor = #colorLiteral(red: 0.1511130137, green: 0.1511130137, blue: 0.1511130137, alpha: 1)
    openModalButtonView.backgroundColor = buttonColor
    openModalButtonView.layer.borderWidth = 0.75
    openModalButtonView.layer.borderColor = buttonColor.cgColor
    openModalButtonView.layer.cornerRadius = 0.25 * openModalButtonView.layer.frame.height
  }
}

extension ViewController: UIViewControllerTransitioningDelegate{
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissAnimator
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return presentAnimator
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}

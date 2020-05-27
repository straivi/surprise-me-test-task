//
//  CountryCodeViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 23.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import NKVPhonePicker

class CountryCodeViewController: UIViewController{
  
  
  var interactor: Interactor? = nil
  
  weak var delegate: CountriesViewControllerDelegate?
  
  //MARK: UI
  @IBOutlet weak var roundRectView: UIView!
  @IBOutlet weak var panView: UIView!
  @IBOutlet weak var panViewFrame: UIView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var contentController: UIView!
  var countrysVC: CountriesViewController?
  
  //MARK: Dependencies
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setupUI()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination
    if let countryController = destination as? CountriesViewController {
      countrysVC = countryController
      countryController.delegate = self
      }
  }
  
  
  //MARK: Setup UI
  func setupUI(){
    setupRoundRect()
    setupPanView()
  }
  func setupRoundRect(){
    roundRectView.layer.cornerRadius = UIScreen.main.bounds.width * 0.1
  }
  func setupPanView(){
    panView.layer.cornerRadius = panView.bounds.height / 2
  }
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    guard let interactor = interactor else { return }
    dismiss(animated: true, completion: nil)
    interactor.hasStarted = false
    interactor.shouldFinish ? interactor.finish(): interactor.cancel()
  }
  @IBAction func closePanAction(_ sender: UIPanGestureRecognizer) {
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

extension CountryCodeViewController: CountriesViewControllerDelegate{
  func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
    
  }
  
  func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
    delegate?.countriesViewController(sender, didSelectCountry: country)
  }
  
  
}

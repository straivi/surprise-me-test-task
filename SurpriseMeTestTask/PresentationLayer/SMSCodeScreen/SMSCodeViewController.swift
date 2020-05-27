//
//  SMSCodeViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 25.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class SMSCodeViewController: UIViewController {
  
  var interactor: Interactor? = nil
  var userNumber: String?
  
  //MARK: UI
  @IBOutlet weak var panView: UIView!
  @IBOutlet weak var roundRectView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var numberTextLabel: UILabel!
  //@IBOutlet weak var backgroundView: UIView!
  //@IBOutlet weak var mainView: UIView!
  @IBOutlet weak var txtOTP1: UITextField!
  @IBOutlet weak var txtOTP2: UITextField!
  @IBOutlet weak var txtOTP3: UITextField!
  @IBOutlet weak var txtOTP4: UITextField!
  
  let dismissAnimator = DismissAnimator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyBoardNotification()
    setupDeledates()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setupUI()
    
  }
  override func viewDidAppear(_ animated: Bool) {
    txtOTP1.becomeFirstResponder()
  }
  
  func setupDeledates(){
    txtOTP1.delegate = self
    txtOTP2.delegate = self
    txtOTP3.delegate = self
    txtOTP4.delegate = self
  }
  
  //MARK: Setup UI
  func setupUI(){
    panView.layer.cornerRadius = 0.5 * panView.frame.height
    roundRectView.layer.cornerRadius = UIScreen.main.bounds.width * 0.1
    numberTextLabel.text = "Please enter 4-digit code We just send to \(userNumber ?? "")"
    let fields = [txtOTP1, txtOTP2, txtOTP3, txtOTP4]
    for textField in fields{
      if let textField = textField{
        textField.layer.masksToBounds = false
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowOpacity = 1.0
      }
    }
    
  }
  
  //MARK: Actions
  @IBAction func sendAgainButtonAction(_ sender: UIButton) {
    dissmissAnimation()
  }
  @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
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
  func dissmissAnimation(){
    guard let interactor = interactor else { return }
    interactor.hasStarted = false
    interactor.shouldFinish ? interactor.finish(): interactor.cancel()
    dismiss(animated: true, completion: nil)
  }
  
}


extension SMSCodeViewController: UITextFieldDelegate{
  //MARK: UITextFieldDelegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.cornerRadius = 5
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 0
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if ((textField.text?.count)! < 1 ) && (string.count > 0) {
      if textField == txtOTP1 {
        txtOTP2.becomeFirstResponder()
      }
      
      if textField == txtOTP2 {
        txtOTP3.becomeFirstResponder()
      }
      
      if textField == txtOTP3 {
        txtOTP4.becomeFirstResponder()
      }
      
      if textField == txtOTP4 {
        txtOTP4.resignFirstResponder()
        fakeCorrectCodeCheck()
      }
      
      textField.text = string
      return false
    } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
      if textField == txtOTP2 {
        txtOTP1.becomeFirstResponder()
      }
      if textField == txtOTP3 {
        txtOTP2.becomeFirstResponder()
      }
      if textField == txtOTP4 {
        txtOTP3.becomeFirstResponder()
      }
      if textField == txtOTP1 {
        txtOTP1.resignFirstResponder()
      }
      
      textField.text = ""
      return false
    } else if (textField.text?.count)! >= 1 {
      textField.text = string
      return false
    }
    return true
  }
  
}

extension SMSCodeViewController{
  //MARK: keyboard adaptation
  func registerForKeyBoardNotification(){
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name:  UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyBoardWillShow(_ notification: Notification){
    let userInfo = notification.userInfo
    let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
  }
  @objc func keyBoardWillHide(){
    scrollView.contentOffset = CGPoint.zero
  }
}

extension SMSCodeViewController: UIViewControllerTransitioningDelegate{
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissAnimator
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor!.hasStarted ? interactor : nil
  }
  
  
}

extension SMSCodeViewController{
  func fakeCorrectCodeCheck(){
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
      self.dissmissAnimation()
    }
    
  }
}

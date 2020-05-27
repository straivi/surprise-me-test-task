//
//  MainViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  var interactor: Interactor? = nil

  //MARK: UI
  @IBOutlet weak var pullLabelView: UIView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var greetingLabel: UILabel!
  @IBOutlet weak var sininTextLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var confirmeButtonView: UIButton!
  @IBOutlet weak var countryCodeButtonView: UIButton!
  @IBOutlet weak var phonenumberTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var aditionalSingupStack: UIStackView!
  @IBOutlet weak var roundTopView: UIView!
  
  //MARK: Dependencies
  let trackImageService: ITrackImageService = ServiceAssembly(coreAssembly: CoreAssembly()).trackImageService
  

  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyBoardNotification()
    setupDelegate()
  }

  override func viewWillLayoutSubviews() {
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    loadTrackImage()
  }

  //MARK: Setup UI
  func setupUI(){
    setupPullLabel()
    setupTrackNameLabel()
    setupGreetingLabel()
    setupSinginTextLabel()
    setupScrollView()
    setupBackgroundView()
    setupTrackImageView()
    setupConfirmeButtonView()
    setupCountryCodeButtonView()
    setupPhonenumberTextfield()
  }
  
  func setupPullLabel(){
    pullLabelView.layer.cornerRadius = pullLabelView.frame.height / 2
  }
  func setupTrackNameLabel(){
    trackNameLabel.text = """
    Sagrada Familia:
    Fast-Track and Audio Tour
    """
  }
  func setupGreetingLabel(){
    let userName = "Anitta"
    greetingLabel.text = "Hi, \(userName)!"
  }
  func setupSinginTextLabel(){
    sininTextLabel.text = "Sing in to have an easier access to your tours and tickets. No password needed - we'll send you authorization code 😼"
  }
  func setupScrollView(){
    scrollView.delaysContentTouches = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
  }
  func setupBackgroundView(){
    roundTopView.layer.cornerRadius = 0.1 * backgroundView.frame.width
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -view.safeAreaInsets.bottom),
      backgroundView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, constant: view.safeAreaInsets.bottom - 50)
    ])
  }
  func setupTrackImageView(){
    trackImageView.layer.cornerRadius = 0.05 * trackImageView.frame.height
    trackImageView.layer.masksToBounds = true
  }
  func setupConfirmeButtonView(){
    confirmeButtonView.layer.cornerRadius = 0.2 * confirmeButtonView.frame.height
  }
  func setupCountryCodeButtonView(){
    countryCodeButtonView.backgroundColor = .white
    countryCodeButtonView.layer.cornerRadius = 0.1 * countryCodeButtonView.frame.height
    countryCodeButtonView.layer.shadowColor = UIColor.black.cgColor
    countryCodeButtonView.layer.shadowRadius = 5
    countryCodeButtonView.layer.shadowOpacity = 0.1
    countryCodeButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
  }
  func setupPhonenumberTextfield(){
    let underline = UIView(frame: CGRect(x: 0, y: phonenumberTextField.frame.height - 8, width: phonenumberTextField.frame.width, height: 1))
    underline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    phonenumberTextField.addSubview(underline)
  }
  func setupCountryCode(){
    let underline = UIView(frame: CGRect(x: 0, y: countryCodeTextField.frame.height - 8, width: countryCodeTextField.frame.width, height: 1))
    underline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    countryCodeTextField.addSubview(underline)
  }
  func setupAditionaly(){
  }
  func setupDelegate(){
    self.phonenumberTextField.delegate = self
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
  
  func loadTrackImage(){
    trackImageService.trackImage { (image) in
      self.trackImageView.image = image
    }
    
  }

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

extension MainViewController: UITextFieldDelegate, UIGestureRecognizerDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    phonenumberTextField.resignFirstResponder()
    return true
  }
}


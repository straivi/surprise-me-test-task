//
//  MainViewController.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import NKVPhonePicker

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
  @IBOutlet weak var aditionButtonView: UIButton!
  @IBOutlet weak var phonenumberTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var aditionalSingupStack: UIStackView!
  @IBOutlet weak var roundTopView: UIView!
  @IBOutlet weak var bottomSinginStackCon: NSLayoutConstraint!
  var countryImage: UIImage!
  var countryCode: String!
  
  //MARK: Dependencies
  let trackImageService: ITrackImageService = ServiceAssembly(coreAssembly: CoreAssembly()).trackImageService
  let smsRequestService: ISMSRequest = ServiceAssembly(coreAssembly: CoreAssembly()).smsRequestService
  var countryCodeViewController: CountryCodeViewController!
  let dismissAnimator = DismissAnimator()
  let presentAnimator = PresentAnimator()

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
    setupCountryCode()
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
    let underline = UIView(frame: CGRect(x: 5, y: countryCodeTextField.frame.height - 8, width: countryCodeTextField.frame.width, height: 1))
    underline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    countryCodeTextField.addSubview(underline)
    countryCodeTextField.isUserInteractionEnabled = false
    
    if let countryImage = countryImage, let countryCode = countryCode{
      countryCodeTextField.text = "+\(countryCode)"
      countryCodeButtonView.setImage(countryImage, for: .normal)
    } else {
      let baseCountry = Country.country(for: .init(countryCode: "US"))
      countryCodeTextField.text = "+\(baseCountry?.phoneExtension ?? "0")"
      countryCodeButtonView.setImage(baseCountry?.flag, for: .normal)
    }
  }
  func setupDelegate(){
    self.phonenumberTextField.delegate = self
  }
  
  //MARK: Actions
  @IBAction func confirmButtonAction(_ sender: UIButton) {
    let vc = sbInitViewController(SMSCodeViewController())
    
    user.phone = "+\(countryCode ?? "")\(phonenumberTextField.text ?? "")"
    vc.userNumber = user.phone
    vc.interactor = interactor
    vc.transitioningDelegate = self
    present(vc, animated: true, completion: nil)
    phonenumberTextField.resignFirstResponder()
    keyBoardWillHide()
    smsRequestService.request(id: user.id, phone: user.phone)
  }
  @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func countruChooseTapped(_ sender: UIButton) {
    
    let vc = sbInitViewController(CountryCodeViewController())
    countryCodeViewController = vc
    countryCodeViewController.delegate = self
    countryCodeViewController.interactor = interactor
    countryCodeViewController.transitioningDelegate = self
    present(countryCodeViewController, animated: true, completion: nil)
  }
  @IBAction func adidionalButtonAction(_ sender: UIButton) {
    let beforeResizeBackground = backgroundView.frame.height
    
    setupLayoutChange()
    
    let afterResizeBackground = backgroundView.frame.height
    var sizeDiference = afterResizeBackground - beforeResizeBackground
    
    let window = UIApplication.shared.keyWindow
    let topPadding = window?.safeAreaInsets.top
    let bottomPadding = window?.safeAreaInsets.bottom
    sizeDiference -= topPadding ?? 0
    sizeDiference -= bottomPadding ?? 0
    
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + sizeDiference)
    
    aditionButtonView.isUserInteractionEnabled = false
    
    UIView.animate(withDuration: 0.3) {
      self.scrollView.contentOffset = CGPoint(x: 0, y: sizeDiference)
    }
  }
  
  func setupLayoutChange(){
    let b1 = createAditionButton(title: "phone number")
    let b2 = createAditionButton(title: "Google")
    let b3 = createAditionButton(title: "Apple")
    let b4 = createAditionButton(title: "Facebook")
    
    bottomSinginStackCon.isActive = false
    
    backgroundView.addSubview(b1)
    backgroundView.addSubview(b2)
    backgroundView.addSubview(b3)
    backgroundView.addSubview(b4)
    
    aditionalSingupStack.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      b1.topAnchor.constraint(equalTo: aditionalSingupStack.bottomAnchor, constant: 30),
      b1.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 60),
      b1.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -60),
      b1.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    NSLayoutConstraint.activate([
      b2.topAnchor.constraint(equalTo: b1.bottomAnchor, constant: 30),
      b2.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 60),
      b2.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -60),
      b2.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    NSLayoutConstraint.activate([
      b3.topAnchor.constraint(equalTo: b2.bottomAnchor, constant: 30),
      b3.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 60),
      b3.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -60),
      b3.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    NSLayoutConstraint.activate([
      b4.topAnchor.constraint(equalTo: b3.bottomAnchor, constant: 30),
      b4.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 60),
      b4.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -60),
      b4.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
      b4.heightAnchor.constraint(equalToConstant: 40),
    ])
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  func createAditionButton(title: String) -> UIButton{
    let button = UIButton(type: .system)
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.black.cgColor
    let finishTitle = "Sing in with \(title)"
    button.setTitle(finishTitle, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  func sbInitViewController<T>(_: T) -> T{
    let vcName = String(describing: T.self)
    let sb = UIStoryboard(name: vcName, bundle: nil)
    let sbView = sb.instantiateViewController(withIdentifier: vcName)
    let vc = sbView as! T
    return vc
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

extension MainViewController: CountriesViewControllerDelegate{
  func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
    
  }
  
  func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
    if let flag = country.flag{
      countryImage = flag
    }
    countryCode = country.phoneExtension
    setupCountryCode()
  }
}

extension MainViewController: UIViewControllerTransitioningDelegate{
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissAnimator
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return presentAnimator
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor!.hasStarted ? interactor : nil
  }
}

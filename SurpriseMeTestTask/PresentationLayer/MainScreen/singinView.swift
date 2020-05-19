//
//  singinView.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

@IBDesignable
class singinView: UIView {
  
  
  //MARK: UI
  var contentView:UIView?
  @IBInspectable var nibName:String?
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
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    xibSetup()
  }

  func xibSetup() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
    contentView = view
  }

  func loadViewFromNib() -> UIView? {
    guard let nibName = nibName else { return nil }
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate( withOwner: self, options: nil).first as? UIView
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    xibSetup()
    contentView?.prepareForInterfaceBuilder()
  }
}

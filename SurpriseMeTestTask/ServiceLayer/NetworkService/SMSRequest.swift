//
//  SMSRequest.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 24.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol ISMSRequest {
  func request(id: String, phone: String)
}

class SMSRequest: ISMSRequest {
  
  var postRequest: IPOSTRequestService
  
  init(postRequest: IPOSTRequestService) {
    self.postRequest = postRequest
  }
  
  func prepareSMS(id: String, phone: String) -> [String: Any]{
    var parametrs = [String:Any]()
    parametrs["id"] = id
    parametrs["phone"] = phone
    return parametrs
  }
  
  func request(id: String, phone: String){
    let url = "https://webhook.site/7ec6c1f6-0ca1-4107-a92e-e577d650dbb3"
    let parametrs = prepareSMS(id: id, phone: phone)
    postRequest.request(for: url, parametrs: parametrs) { (data, error) in
      if let _ = error {
      }
      
      guard let _ = data else { return }
      
    }
  }
}

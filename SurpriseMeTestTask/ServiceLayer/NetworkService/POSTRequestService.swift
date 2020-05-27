//
//  POSTRequestService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 24.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class POSTRequestService: IPOSTRequestService {
  let networkService: IURLNetworkService
  
  init(networkService: IURLNetworkService) {
    self.networkService = networkService
  }
  
  func request(for path: String, parametrs: [String: Any], callback: @escaping (Data?, Error?) -> Void){
    guard let url = NSURL(string: path) else { return }
    
    var request = URLRequest(url: url as URL)
    
    request.httpMethod = "POST"
    let jsonData = try? JSONSerialization.data(withJSONObject: parametrs, options: [])
    request.httpBody = jsonData
    
    networkService.dataTask(for: request, callback: callback)
  }
}


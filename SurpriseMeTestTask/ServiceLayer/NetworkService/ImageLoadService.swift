//
//  ImageLoadService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class ImageLoadService: IImageLoadService {
  
  let networkService: IURLNetworkService
  
  init(networkService: IURLNetworkService) {
    self.networkService = networkService
  }
  
  func requestPhoto(for path: String, callback: @escaping (Data?, Error?) -> Void) {
    guard let url = NSURL(string: path) else { return }
    
    var request = URLRequest(url: url as URL)
    request.httpMethod = "get"
    networkService.dataTask(for: request, callback: callback)
  }
}

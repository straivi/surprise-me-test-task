//
//  DataFetchService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class DataFetchService: IDataFetchService {
  
  let imageLoadService: IImageLoadService
  
  init(imageLoadService: IImageLoadService) {
    self.imageLoadService = imageLoadService
  }
  
  func fetchImage(for url: String, callback: @escaping(UIImage?, Error?) -> Void) {
    imageLoadService.requestPhoto(for: url) { (data, error) in
      if let error = error {callback(nil, error)}
      
      if let data = data{
        let image = UIImage(data: data)
        callback(image, nil)
      }
    }
  }
  
}

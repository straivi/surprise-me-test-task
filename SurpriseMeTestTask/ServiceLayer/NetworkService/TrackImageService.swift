//
//  TrackImageService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

protocol ITrackImageService {
  func trackImage( callback: @escaping(UIImage?)->Void)
}

class TrackImageService: ITrackImageService {
  
  let imageURLService: IDataFetchService
  
  init(imageURLService: IDataFetchService) {
    self.imageURLService = imageURLService
  }
  
  func trackImage( callback: @escaping(UIImage?)->Void){
    let url = "https://app.surprizeme.ru/media/store/1186_i1KaYnj_8DuYTzc.jpg"
    imageURLService.fetchImage(for: url) { (image, error) in
      if let _ = error, let _ = image{
        // здесь строит рассмотреть 2 случая когда картнки нет и когда вернуло ошибку
        let errorImage = #imageLiteral(resourceName: "trackPlaceholder") //любая пикча информирующая об ошибке загрузки
        callback(errorImage)
      }
      
      if let image = image{
        callback(image)
      }
    }
  }
}

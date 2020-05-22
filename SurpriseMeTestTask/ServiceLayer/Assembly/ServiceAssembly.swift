//
//  ServiceAssembly.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

protocol IServiceAssembly {
  var imageURLService: IDataFetchService { get }
}

class ServiceAssembly: IServiceAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  lazy var imageLoadService: IImageLoadService = ImageLoadService(networkService: coreAssembly.networkService)
  
  lazy var imageURLService: IDataFetchService = DataFetchService(imageLoadService: imageLoadService)
  
  lazy var trackImageService: ITrackImageService = TrackImageService(imageURLService: imageURLService)
}

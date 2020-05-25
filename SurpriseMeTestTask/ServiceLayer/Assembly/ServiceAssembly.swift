//
//  ServiceAssembly.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

protocol IServiceAssembly {
  var trackImageService: ITrackImageService { get }
  
  var smsRequestService: ISMSRequest { get }
}

class ServiceAssembly: IServiceAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  private lazy var imageLoadService: IImageLoadService = ImageLoadService(networkService: coreAssembly.networkService)
  private lazy var postRequestService: IPOSTRequestService = POSTRequestService(networkService: coreAssembly.networkService)
  
  private lazy var imageURLService: IDataFetchService = DataFetchService(imageLoadService: imageLoadService)
  
  lazy var trackImageService: ITrackImageService = TrackImageService(imageURLService: imageURLService)
  lazy var smsRequestService: ISMSRequest = SMSRequest(postRequest: postRequestService)
}

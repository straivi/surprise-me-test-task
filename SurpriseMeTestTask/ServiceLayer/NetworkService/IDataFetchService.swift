//
//  IDataFetchService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

protocol IDataFetchService {
  func fetchImage(for url: String, callback: @escaping(UIImage?, Error?) -> Void)
}

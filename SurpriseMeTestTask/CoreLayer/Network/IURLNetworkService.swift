//
//  IURLNetworkService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol IURLNetworkService {
  func dataTask(for request: URLRequest, callback: @escaping(Data?, Error?) -> Void)
}

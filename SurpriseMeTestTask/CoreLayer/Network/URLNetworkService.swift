//
//  URLNetworkService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class URLNetworkService: IURLNetworkService {
  func dataTask(for request: URLRequest, callback: @escaping (Data?, Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, respones, error) in
      DispatchQueue.main.async { callback(data, error) }
    }
    DispatchQueue.global(qos: .utility).async {
      task.resume()
    }
  }
}

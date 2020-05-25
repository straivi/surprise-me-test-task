//
//  IPOSTRequestService.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 24.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol IPOSTRequestService {
  func request(for path: String, parametrs: [String: Any], callback: @escaping (Data?, Error?) -> Void)
}

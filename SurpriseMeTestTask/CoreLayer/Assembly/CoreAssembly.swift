//
//  CoreAssembly.swift
//  SurpriseMeTestTask
//
//  Created by  Matvey on 20.05.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
  var networkService: IURLNetworkService { get }
}

class CoreAssembly: ICoreAssembly {
  lazy var networkService: IURLNetworkService = URLNetworkService()
}

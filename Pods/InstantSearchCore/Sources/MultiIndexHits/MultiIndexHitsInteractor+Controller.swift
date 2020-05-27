//
//  MultiIndexHitsInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension MultiIndexHitsInteractor {
  
  func connectController<Controller: MultiIndexHitsController>(_ controller: Controller) {
    
    controller.hitsSource = self
    
    onRequestChanged.subscribe(with: controller) { controller, _ in
      controller.scrollToTop()
      }.onQueue(.main)
    
    onResultsUpdated.subscribePast(with: controller) { controller, _ in
      controller.reload()
      }.onQueue(.main)
    
    controller.reload()
  }
  
}

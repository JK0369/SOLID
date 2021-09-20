//
//  Application_ApplyFactory.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import Foundation

class Application_ApplyFactory {
    let serviceFactory: ServiceFactory
    var service: Service?

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
        service = makeService()
    }

    func makeService() -> Service {
        return serviceFactory.makeService()
    }
}


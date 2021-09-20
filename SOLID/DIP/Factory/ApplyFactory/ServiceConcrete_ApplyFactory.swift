//
//  ServiceConcrete_ApplyFactory.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import Foundation

class ServiceConcrete_ApplyFactory: ServiceFactory {
    func makeService() -> Service {
        return ServiceConcreteImpl()
    }
}

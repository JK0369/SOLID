//
//  Application_NotFactory.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import Foundation

class Application_NotFactory {
    var service: ServiceConcrete_NotFactory?

    init() {
        service = makeService()
    }

    /// 구현체에 의존하는 상태
    func makeService() -> ServiceConcrete_NotFactory {
        return ServiceConcrete_NotFactory()
    }
}

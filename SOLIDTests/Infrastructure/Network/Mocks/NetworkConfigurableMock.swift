//
//  NetworkConfigurableMock.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/23.
//

import Foundation
@testable import SOLID

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}

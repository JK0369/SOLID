//
//  NetworkSessionManagerMock.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/23.
//

import Foundation
@testable import SOLID

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?

    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}

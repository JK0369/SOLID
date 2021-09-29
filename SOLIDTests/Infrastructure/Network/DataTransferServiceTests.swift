//
//  DataTransferServiceTests.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/23.
//

import XCTest
@testable import SOLID

// decode가 잘 동작하는지에 대해 필요한 모델
private struct MockModel: Decodable {
    let name: String
}

class DataTransferServiceTests: XCTestCase {

    private enum DataTransferErrorMock: Error {
        case someError
    }

    // decode테스트 - response data 형식이 맞는 경우 디코딩이 정상 동작하는지 테스트
    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should decode mock object")

        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                             data: responseData,
                                                                                                             error: nil))

        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get)) { result in
            do {
                let object = try result.get()
                XCTAssertEqual(object.name, "Hello")
                expectation.fulfill()
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // 정의한 데이터 형식과 다르게 response가 내려오는 경우 decode에러가 발생하는지 테스트
    func test_whenInvalidResponse_shouldNotDecodeObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should not decode mock object")

        let responseData = #"{"age": 20}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                             data: responseData,
                                                                                                             error: nil))

        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenBadRequestReceived_shouldRethrowNetworkError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw network error")

        let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: responseData,
                                                                                                             error: DataTransferErrorMock.someError))

        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {

                if case DataTransferError.networkFailure(NetworkError.error(statusCode: 500, _)) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // response에 데이터가 비어있는 경우 noResponse에러로 잘 처리하는지 테스트
    func test_whenNoDataReceived_shouldThrowNoDataError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw no data error")

        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: nil,
                                                                                                             error: nil))

        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case DataTransferError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}

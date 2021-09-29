//
//  NetworkServiceTests.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/23.
//

import XCTest
@testable import SOLID

class NetworkServiceTests: XCTestCase {

    class NetworkErrorLoggerMock: NetworkErrorLogger {
        var loggedErrors: [Error] = []
        func log(request: URLRequest) { }
        func log(responseData data: Data?, response: URLResponse?) { }
        func log(error: Error) { loggedErrors.append(error) }
    }

    private enum NetworkErrorMock: Error {
        case someError
    }

    // mock데이터에 대한 request 시 response가 잘 오는지 테스트
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")

        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: expectedResponseData,
                                                                                  error: nil))
        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "http://mock.test.com", method: .get), completion: { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            expectation.fulfill()
        })

        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // error를 request에 담아서 response에서 error가 잘 떨어지는지 확인하는 코드
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")

        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: cancelledError as Error))
        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }

                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // url의 path에 잘못된 값이 들어간 경우 error로 정상적으로 응답받는지 테스트
    func test_whenMalformedUrlPassed_shouldReturnUrlGenerationError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")

        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: expectedResponseData,
                                                                                                  error: nil))
        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "-;@,?:ą", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should throw url generation error")
            } catch let error {
                guard case NetworkError.urlGeneration = error else {
                    XCTFail("Should throw url generation error")
                    return
                }

                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // status code가 400이상인 경우 error로 정상적으로 응답받는지 테스트
    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")

        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                  data: nil,
                                                                                                  error: NetworkErrorMock.someError))
        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.error(let statusCode, _) = error {
                    XCTAssertEqual(statusCode, 500)
                    expectation.fulfill()
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // internet connection error 발생
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")

        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: error as Error))

        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }

                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    // status code 관련 테스트
    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        //when
        let sut = NetworkError.notConnected
        //then
        XCTAssertFalse(sut.hasStatusCode(200))
    }

    func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode_() {
        //when
        let sut = NetworkError.error(statusCode: 400, data: nil)
        //then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }

    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldLogThisError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")

        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkErrorLogger = NetworkErrorLoggerMock()
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: error as Error),
                                        logger: networkErrorLogger)
        //when
        _ = sut.request(endpoint: Endpoint<Void>(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }

                expectation.fulfill()
            }
        }

        //then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(networkErrorLogger.loggedErrors.contains {
            guard case NetworkError.notConnected = $0 else { return false }
            return true
        })
    }
}

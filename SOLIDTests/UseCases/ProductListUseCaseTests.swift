//
//  ProductListUseCaseTests.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/20.
//

import XCTest
@testable import SOLID

// useCase를 테스트하는 경우 - useCase는 그대로 두고 다른 요인을 바꾸어도 기대하는 값이 나오는지 체크
class ProductListUseCaseTests: XCTestCase {
    var sampleDataSource = [Product(title: "아이패드 프로 5세대(13`)", price: 300, isSale: true),
                            Product(title: "아이폰13", price: 200, isSale: false),
                            Product(title: "애플워치7", price: 100, isSale: false),
                            Product(title: "아이폰SE", price: 50, isSale: true),
                            Product(title: "아이폰12", price: 130, isSale: true),
                            Product(title: "애플워치6", price: 70, isSale: true),]

    func testProductListUseCase_whenAllIsNotSaleProduct_thenCalculateAccuracy() {
        // given
        let useCase = ProductListUseCaseImpl()

        // when
        let data = sampleDataSource.map { Product(title: $0.title, price: $0.price, isSale: false) }

        // then
        let result = useCase.calc(data)
        let expectValue = data.map { $0.price }.reduce(0, +)

        XCTAssertTrue(expectValue == result)
    }

    func testProductListUseCase_whenAllIsAllSaleProduct_thenCalculateAccuracy() {
        // given
        let useCase = ProductListUseCaseImpl()

        // when
        let data = sampleDataSource.map { Product(title: $0.title, price: $0.price, isSale: true) }

        // then
        let result = useCase.calc(data)
        let expectValue = data.map { $0.price * 0.8 }.reduce(0, +)

        XCTAssertTrue(expectValue == result)
    }

}

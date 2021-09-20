//
//  ProductListViewModelTests.swift
//  SOLIDTests
//
//  Created by 김종권 on 2021/09/20.
//

@testable import SOLID
import XCTest

// ViewModel 테스트 - ViewModel은 그대로 두고, 안에서 사용하는 UseCase를 mock으로 바꾸어 가며 테스트
class ProductListViewModelTests: XCTestCase {

    let sampleDataSourceForTest = [Product(title: "아이패드 프로 5세대(13`)", price: 300, isSale: true),
                                   Product(title: "아이폰13", price: 200, isSale: false),
                                   Product(title: "애플워치7", price: 100, isSale: false),
                                   Product(title: "아이폰SE", price: 50, isSale: true),
                                   Product(title: "아이폰12", price: 130, isSale: true),
                                   Product(title: "애플워치6", price: 70, isSale: true),]

    class ProductListUseCaseMock: ProductListUseCase {
        func calc(_ productList: [Product]) -> Double {
            var totalFee = 0.0
            productList.forEach { product in
                totalFee += product.isSale ? product.price * 0.5 : product.price
            }
            return totalFee
        }
    }

    func test_whenUseCaseChanged_thenSuccessAccuracy() {
        // given
        let useCase = ProductListUseCaseMock()
        let viewModel = ProductListViewModelImpl(productListUseCase: useCase)

        // when (= input)
        viewModel.didTapCellForRow(at: 0)
        viewModel.didTapCellForRow(at: 1)
        viewModel.didTapCalButton()

        // then (= output)
        XCTAssertEqual(viewModel.totalFee.value, "총 금액 = \(300 * 0.5 + 200)")
    }
}

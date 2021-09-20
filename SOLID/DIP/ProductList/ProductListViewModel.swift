//
//  ProductListViewModel.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import RxSwift
import RxCocoa

protocol ProductListViewModelInput {
    func didTapCalButton()
    func didTapBuyButton()
    func didTapCellForRow(at index: Int)
}

protocol ProductListViewModelOutput {
    var totalFee: BehaviorRelay<String> { get }
    var sampleDataSource: [Product] { get }
}

protocol ProductListViewModel: ProductListViewModelInput, ProductListViewModelOutput {}

class ProductListViewModelImpl: ProductListViewModel {

    let productListUseCase: ProductListUseCase
    init(productListUseCase: ProductListUseCase) {
        self.productListUseCase = productListUseCase
    }

    // Outout

    var totalFee: BehaviorRelay<String> = .init(value: "총 금액 = \(0)")
    var sampleDataSource = [Product(title: "아이패드 프로 5세대(13`)", price: 300, isSale: true),
                            Product(title: "아이폰13", price: 200, isSale: false),
                            Product(title: "애플워치7", price: 100, isSale: false),
                            Product(title: "아이폰SE", price: 50, isSale: true),
                            Product(title: "아이폰12", price: 130, isSale: true),
                            Product(title: "애플워치6", price: 70, isSale: true),]

    // Input

    func didTapCalButton() {
        let resultFee = productListUseCase.calc(sampleDataSource.filter { $0.isSelected })
        totalFee.accept("총 금액 = \(resultFee)")
    }

    func didTapBuyButton() {
        totalFee.accept("구매 완료")
    }

    func didTapCellForRow(at index: Int) {
        sampleDataSource[index].isSelected.toggle()
    }
}

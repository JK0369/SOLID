//
//  ProductListUseCase.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import Foundation

protocol ProductListUseCase {
    func calc(_ productList: [Product]) -> Double
}

final class ProductListUseCaseImpl: ProductListUseCase {
    func calc(_ productList: [Product]) -> Double {
        var totalFee = 0.0
        productList.forEach { product in
            totalFee += product.isSale ? product.price * 0.8 : product.price
        }
        return totalFee
    }
}

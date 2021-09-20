//
//  ProductListDIContainer.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import Foundation

final class ProductListDIContainer {

    lazy var productListViewController: ProductListViewController = {
        return ProductListViewController.create(with: productListViewModel)
    }()

    // Private

    private lazy var productListUseCaseImpl: ProductListUseCase = {
        return ProductListUseCaseImpl()
    }()

    private lazy var productListViewModel: ProductListViewModel = {
    return ProductListViewModelImpl(productListUseCase: productListUseCaseImpl)
    }()
}

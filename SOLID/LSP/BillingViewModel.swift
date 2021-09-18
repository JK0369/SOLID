//
//  BillingViewModel.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol BillingViewModelInput {
    func didTapButton()
}

protocol BillingViewModelOutput {
    var licenseInfo: BehaviorRelay<String> { get }
}

protocol BillingViewModel: BillingViewModelInput, BillingViewModelOutput {}

class BillingViewModelImpl: BillingViewModel {

    let licenseUseCase: LicenseUseCase

    init(licenseUseCase: LicenseUseCase) {
        self.licenseUseCase = licenseUseCase
    }

    // Output

    let licenseInfo: BehaviorRelay<String> = .init(value: "")

    // Input

    func didTapButton() {
        // 현재 사용한 금액을 2000원이라 가정
        let result = licenseUseCase.calcFee(2000)
        licenseInfo.accept("계산된 최종 금액 = \(result)")
    }

}

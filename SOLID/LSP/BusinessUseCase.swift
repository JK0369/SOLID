//
//  BusinessUseCase.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/18.
//

import Foundation

class BusinessUseCase: LicenseUseCase {
    func calcFee(_ currentFee: Int) -> Double {
        return Double(currentFee) * 0.7
    }
}

//
//  LicenseUseCase.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/18.
//

import Foundation

protocol LicenseUseCase {
    func calcFee(_ currentFee: Int) -> Double
}

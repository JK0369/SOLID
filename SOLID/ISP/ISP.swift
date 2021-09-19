//
//  ISP.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/19.
//

import Foundation

class Personal {
    let calculator: CalPersonal = Calculator(expensePrice: 1000)

    func calFee() {
        print(calculator.calFeePersonal())
    }
}

class Business {
    let calculator: CalBusiness = Calculator(expensePrice: 2000)

    func calFee() {
        print(calculator.calFeeBusiness())
    }
}

protocol CalPersonal {
    func calFeePersonal() -> Double
}

protocol CalBusiness {
    func calFeeBusiness() -> Double
}

class Calculator: CalPersonal, CalBusiness {

    var expensePrice: Double

    init(expensePrice: Double) {
        self.expensePrice = expensePrice
    }

    func calFeePersonal() -> Double {
        return expensePrice * 1.2
    }

    func calFeeBusiness() -> Double {
        return expensePrice * 0.7
    }
}

//
//  ButtonsUseCase.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/21.
//

import Foundation

protocol ButtonsUseCase {
    var redButtonCnt: Int { get set }
    var blueButtonCnt: Int { get set }
}

final class ButtonsUseCaseImpl: ButtonsUseCase {
    var redButtonCnt: Int {
        get {
            return UserDefaults.standard.integer(forKey: "redButton")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "redButton")
        }
    }

    var blueButtonCnt: Int {
        get {
            return UserDefaults.standard.integer(forKey: "blueButton")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "blueButton")
        }
    }
}

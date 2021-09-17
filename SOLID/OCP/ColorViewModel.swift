//
//  ColorViewModel.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol ColorViewModelInput {
    func viewDidLoad()
    func didTapBlueButton()
    func didTapRedButton()
}

protocol ColorViewModelOutput {
    var buttonInfo: BehaviorRelay<String> { get }
}

protocol ColorViewModel: ColorViewModelInput, ColorViewModelOutput {}

final class ColorViewModelImpl: ColorViewModel {

    // Output

    var buttonInfo: BehaviorRelay<String> = .init(value: "")

    private var colorUseCase: ColorUseCase?

    init(colorUseCase: ColorUseCase) {
        self.colorUseCase = colorUseCase
    }

    // Input

    func viewDidLoad() {
        loadColorInfo()
    }

    func didTapBlueButton() {
        colorUseCase?.updateColor(with: ColorModel(color: .blue), completion: { colorModel in
            buttonInfo.accept("파란 버튼 누적 카운트 = \(colorModel.currentBlueColor),\n빨간 버튼 누적 카운트 = \(colorModel.currentRedColor)")
        })
    }

    func didTapRedButton() {
        colorUseCase?.updateColor(with: ColorModel(color: .red), completion: { colorModel in
            buttonInfo.accept("파란 버튼 누적 카운트 = \(colorModel.currentBlueColor),\n빨간 버튼 누적 카운트 = \(colorModel.currentRedColor)")
        })
    }

    // Private

    private func loadColorInfo() {
        colorUseCase?.getCurrentColorCount(completion: { colorModel in
            buttonInfo.accept("파란 버튼 누적 카운트 = \(colorModel.currentBlueColor),\n빨간 버튼 누적 카운트 = \(colorModel.currentRedColor)")
        })
    }
}


//
//  ButtonsViewModel.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/21.
//

import Foundation

struct ButtonsViewModelActions {
    let showRedButton: (Int) -> Void
    let showBlueButton: (Int) -> Void
}

protocol ButtonsViewModelInput {
    func didTapRedButton()
    func didTapBlueButton()
}

protocol ButtonsViewModelOutput {

}

protocol ButtonsViewModel: ButtonsViewModelInput, ButtonsViewModelOutput {}

final class ButtonsViewModelImpl: ButtonsViewModel {

    private let actions: ButtonsViewModelActions
    private var buttonsUseCase: ButtonsUseCase

    init(actions: ButtonsViewModelActions, buttonUseCase: ButtonsUseCase) {
        self.actions = actions
        self.buttonsUseCase = buttonUseCase
    }

    // Input

    func didTapRedButton() {
        buttonsUseCase.redButtonCnt += 1
        actions.showRedButton(buttonsUseCase.redButtonCnt)
    }

    func didTapBlueButton() {
        buttonsUseCase.blueButtonCnt += 1
        actions.showBlueButton(buttonsUseCase.blueButtonCnt)
    }
}

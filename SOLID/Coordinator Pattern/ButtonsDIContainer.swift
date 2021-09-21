//
//  ButtonsDIContainer.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/21.
//

import Foundation
import UIKit

class ButtonsDIContainer {

    func makeButtonCoordinator(navigationController: UINavigationController) -> ButtonsCoordinator {
        return ButtonsCoordinator(navigationController: navigationController, dependencies: self)
    }

    // Private

    private func makeButtonsUseCaseImpl() -> ButtonsUseCase {
        return ButtonsUseCaseImpl()
    }

    private func makeButtonsViewModel(actions: ButtonsViewModelActions) -> ButtonsViewModel {
        return ButtonsViewModelImpl(actions: actions, buttonUseCase: makeButtonsUseCaseImpl())
    }
}

extension ButtonsDIContainer: ButtonsCoordinatorDependencies {
    func makeButtonViewController(actions: ButtonsViewModelActions) -> ButtonsViewController {
        return ButtonsViewController.create(with: makeButtonsViewModel(actions: actions))
    }

    func makeRedViewController(tapCount: Int) -> UIViewController {
        return RedViewController.create(tapCount: tapCount)
    }

    func makeBlueViewController(tapCount: Int) -> UIViewController {
        return BlueViewController.create(tapCount: tapCount)
    }
}

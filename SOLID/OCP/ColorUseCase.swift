//
//  ColorUseCase.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import Foundation

protocol ColorUseCase {
    func updateColor(with: ColorModel, completion: (ColorModel) -> Void)
    func getCurrentColorCount(completion: (ColorModel) -> Void)
}

final class ColorUseCaseImpl: ColorUseCase {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    func updateColor(with colorModel: ColorModel, completion: (ColorModel) -> Void) {
        var currentBlueCnt = keychainService.getBlueCount() ?? 0
        var currentRedCnt = keychainService.getRedCount() ?? 0

        // Business logic: 서로 두 배 이상 차이나면 적은 수를 *2 후 추가하는 로직
        switch colorModel.color {
        case .blue:
            if currentBlueCnt * 2 < currentRedCnt {
                currentBlueCnt = currentBlueCnt * 2 + 1
            } else {
                currentBlueCnt += 1
            }
        case .red:
            if currentRedCnt * 2 < currentBlueCnt {
                currentRedCnt = currentRedCnt * 2 + 1
            } else {
                currentRedCnt += 1
            }
        }

        updateColor(currentBlueCnt, currentRedCnt)

        let colorModel = ColorModel(color: colorModel.color,
                                    currentBlueColor: currentBlueCnt,
                                    currentRedColor: currentRedCnt)
        completion(colorModel)
    }

    func getCurrentColorCount(completion: (ColorModel) -> Void) {
        let currentBlueCnt = keychainService.getBlueCount() ?? 0
        let currentRedCnt = keychainService.getRedCount() ?? 0
        let colorModel = ColorModel(color: .blue,
                                    currentBlueColor: currentBlueCnt,
                                    currentRedColor: currentRedCnt)
        completion(colorModel)
    }

    private func updateColor(_ blueColorCount: Int, _ redColorCount: Int) {
        keychainService.saveBlueCount(blueColorCount)
        keychainService.saveRedCount(redColorCount)
    }
}

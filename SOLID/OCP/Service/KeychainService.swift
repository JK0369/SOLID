//
//  KeychainService.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import Foundation
import KeychainAccess

fileprivate struct KeychainKey {
    static let blueCount = "blueCount"
    static let redCount = "redCount"
}

protocol KeychainService {
    func saveBlueCount(_ count: Int)
    func saveRedCount(_ count: Int)

    func getBlueCount() -> Int?
    func getRedCount() -> Int?
}

class KeychainServiceImpl: KeychainService {
    private let keychainRepository: KeychainRepository

    init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }

    // Save

    public func saveBlueCount(_ count: Int) {
        keychainRepository.save(KeychainKey.blueCount, String(count))
    }

    public func saveRedCount(_ count: Int) {
        keychainRepository.save(KeychainKey.redCount, String(count))
    }

    // Get

    public func getBlueCount() -> Int? {
        return Int(keychainRepository.get(KeychainKey.blueCount) ?? "0")
    }

    public func getRedCount() -> Int? {
        return Int(keychainRepository.get(KeychainKey.redCount) ?? "0")
    }
}

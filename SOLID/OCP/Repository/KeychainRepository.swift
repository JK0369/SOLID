//
//  KeychainRepository.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import Foundation
import KeychainAccess

public protocol KeychainRepository {
    func save(_ key: String, _ value: String)
    func get(_ key: String) -> String?
    func delete(_ key: String)
    func removeAll()
}

class KeychainRepositoryImpl: KeychainRepository {
    public static let shared = KeychainRepositoryImpl()
    private init() {}

    let keychain = Keychain()

    func save(_ key: String, _ value: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    func get(_ key: String) -> String? {
        do {
            guard let key = try keychain.get(key) else { return nil }
            return key
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func delete(_ key: String) {
        do {
            try keychain.remove(key)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeAll() {
        do {
            try keychain.removeAll()
        } catch {
            print(error.localizedDescription)
        }
    }
}

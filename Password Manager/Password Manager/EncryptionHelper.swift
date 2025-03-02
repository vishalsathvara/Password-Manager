//
//  EncryptionHelper.swift
//  Password Manager
//
//  Created by admin on 01/03/25.
//

import Security
import CryptoKit
import SwiftUI

struct EncryptionHelper {
    private static var key: SymmetricKey = loadKey()

    private static func loadKey() -> SymmetricKey {
        if let savedKeyData = KeychainHelper.getKey() {
            return SymmetricKey(data: savedKeyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            KeychainHelper.saveKey(newKey)
            return newKey
        }
    }

    static func encrypt(text: String) -> String? {
        let data = text.data(using: .utf8)!
        let sealedBox = try? AES.GCM.seal(data, using: key)
        return sealedBox?.combined?.base64EncodedString()
    }

    static func decrypt(encryptedText: String) -> String? {
        guard let data = Data(base64Encoded: encryptedText),
              let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let decryptedData = try? AES.GCM.open(sealedBox, using: key) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
}

// Helper to Store Key in Keychain
class KeychainHelper {
    static let keychainKey = "encryptionKey"
    static func saveKey(_ key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainKey,
            kSecValueData: keyData
        ] as [String: Any]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving key: \(status)")
        }
    }

    static func getKey() -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainKey,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Error retrieving key: \(status)")
            return nil
        }
    }

}

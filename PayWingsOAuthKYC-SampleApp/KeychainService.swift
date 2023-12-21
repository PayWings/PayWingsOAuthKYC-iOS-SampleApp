//
//  KeychainService.swift
//  PayWingsOAuthKYC-SampleApp
//
//  Created by Tjasa Jan on 30/11/2023.
//

import Foundation
import LocalAuthentication


extension KeychainService {
    
    enum wAccount : String {
        case encryption
    }
    enum wService : String {
        case oauth
    }
}

struct KeychainService {
    
    static func getBiometricSecAccessControl() -> SecAccessControl {
        var access: SecAccessControl?
        var error: Unmanaged<CFError>?
        
        access = SecAccessControlCreateWithFlags(nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .biometryCurrentSet,
            &error)
        precondition(access != nil, "SecAccessControlCreateWithFlags failed")
        return access!
    }
    
    static func storeGenericPasswordFor(account: wAccount, service: wService, password: String, biometryProtected: Bool = false) -> Bool {
        
        if password.isEmpty {
            return false
        }
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.rawValue,
            kSecAttrService as String: service.rawValue,
            kSecValueData as String: passwordData
        ]
        if biometryProtected {
            query[kSecAttrAccessControl as String] = getBiometricSecAccessControl()
            query[kSecUseOperationPrompt as String] = NSLocalizedString("Authentication required to access secure data.", comment: "")
        }
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            return updateGenericPasswordFor(account: account, service: service, password: password, biometryProtected: biometryProtected)
        default:
            return false
        }
        return true
    }

    static func getGenericPasswordFor(account: wAccount, service: wService, biometryProtected: Bool = false) -> String? {
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.rawValue,
            kSecAttrService as String: service.rawValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        if biometryProtected {
            query[kSecAttrAccessControl as String] = getBiometricSecAccessControl()
            query[kSecUseOperationPrompt as String] = NSLocalizedString("Authentication required to access secure data.", comment: "")
        }
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        guard let existingItem = item as? [String: Any],
            let valueData = existingItem[kSecValueData as String] as? Data,
            let value = String(data: valueData, encoding: .utf8) else {
            return nil
        }
        return value
    }
    
    static func updateGenericPasswordFor(account: wAccount, service: wService, password: String, biometryProtected: Bool = false) -> Bool {
        
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.rawValue,
            kSecAttrService as String: service.rawValue
        ]
        if biometryProtected {
            query[kSecAttrAccessControl as String] = getBiometricSecAccessControl()
        }

        let attributes: [String: Any] = [
            kSecValueData as String: passwordData
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else {
            return false
        }
        return true
    }
    
    static func deleteGenericPasswordFor(account: wAccount, service: wService, biometryProtected: Bool = false) -> Bool {
      
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.rawValue,
            kSecAttrService as String: service.rawValue
        ]
        if biometryProtected {
            query[kSecAttrAccessControl as String] = getBiometricSecAccessControl()
            query[kSecUseOperationPrompt as String] = NSLocalizedString("Authentication required to access secure data.", comment: "")
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return false
        }
        return true
    }
}

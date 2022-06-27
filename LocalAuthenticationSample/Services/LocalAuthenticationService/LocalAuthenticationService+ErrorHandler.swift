//
//  LocalAuthenticationService+ErrorHandler.swift
//  LocalAuthenticationSample
//
//  Created by Arsenii Kovalenko on 27.06.2022.
//

import Foundation
import LocalAuthentication.LAError


protocol LAErrorHandlable {
    func handleEvaluationError(_ error: NSError, completion: LocalAuthenticationCompletion)
}

extension LocalAuthenticationService: LAErrorHandlable {
    func handleEvaluationError(_ error: NSError, completion: LocalAuthenticationCompletion) {
        switch LAError(_nsError: error).code {
        case .systemCancel:
            completion(.failure(.systemCancel))
        case .appCancel:
            completion(.failure(.appCancel))
        case .passcodeNotSet:
            completion(.failure(.passcodeNotSet))
        case .biometryNotAvailable:
            completion(.failure(.biometryNotAvailable))
        case .biometryNotEnrolled:
            completion(.failure(.biometryNotEnrolled))
        case .biometryLockout:
            completion(.failure(.biometryLockout))
        case .userCancel:
            completion(.failure(.userCancel))
        case .userFallback:
            completion(.failure(.userFallback))
        case .authenticationFailed:
            completion(.failure(.authenticationFailed))
        default:
            completion(.failure(.unknown(error.localizedDescription)))
        }
    }
}


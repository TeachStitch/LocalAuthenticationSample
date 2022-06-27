//
//  Errors.swift
//  LocalAuthenticationSample
//
//  Created by Arsenii Kovalenko on 27.06.2022.
//

import Foundation

enum EvaluationError: Error {
    case systemCancel
    case appCancel
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case userCancel
    case userFallback
    case authenticationFailed
    case unknown(String)
}

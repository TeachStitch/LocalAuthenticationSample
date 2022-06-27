//
//  LocalAuthenticationService.swift
//  LocalAuthenticationSample
//
//  Created by Arsenii Kovalenko on 27.06.2022.
//

import Foundation
import LocalAuthentication

typealias LocalAuthenticationCompletion = (_ result: Result<Void, EvaluationError>) -> Void

protocol LocalAuthenticationServiceContext {
    var biometryType: LocalAuthenticationService.BiometryType { get }
    func requestAuthentication(_ policy: LocalAuthenticationService.Policy, reason: String, completion: @escaping LocalAuthenticationCompletion)
}

class LocalAuthenticationService: LocalAuthenticationServiceContext {
    
    private let localizedReason: String?
    private let fallBackTitle: String?
    private let cancelTitle: String?
    private let touchIDAuthenticationAllowableReuseDuration: TimeInterval
    private var evaluationError: NSError?
    
    enum BiometryType {
        case touchId
        case faceId
        case none
    }
    
    enum Policy {
        case biometricsOnly
        case allWays
    }
    
    var biometryType: BiometryType {
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchId
        case .faceID:
            return .faceId
        @unknown default:
            preconditionFailure("Unknown biometry type")
        }
    }
    
    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedFallbackTitle = fallBackTitle
        context.localizedCancelTitle = cancelTitle
        context.touchIDAuthenticationAllowableReuseDuration = touchIDAuthenticationAllowableReuseDuration
        if let localizedReason = localizedReason {
            context.localizedReason = localizedReason
        }
        
        return context
    }()
    
    
    init(with model: AuthenticationModelProvider) {
        fallBackTitle = model.fallBackTitle.title
        cancelTitle = model.cancelTitle.title
        touchIDAuthenticationAllowableReuseDuration = model.touchIDAuthenticationAllowableReuseDuration.duration
        localizedReason = model.localizedReason
    }
    
    func requestAuthentication(_ policy: Policy, reason: String, completion: @escaping LocalAuthenticationCompletion) {
        let biometricsPolicy: LAPolicy
        switch policy {
        case .biometricsOnly:
            biometricsPolicy = .deviceOwnerAuthenticationWithBiometrics
        case .allWays:
            biometricsPolicy = .deviceOwnerAuthentication
        }
        
        guard canEvaluatePolicy(biometricsPolicy) else {
            if let evaluationError = evaluationError {
                self.handleEvaluationError(evaluationError, completion: completion)
            }
            return
        }
        
        context.evaluatePolicy(biometricsPolicy, localizedReason: reason) { authenticated, error in
            guard authenticated else {
                if let error = error as? NSError {
                    self.handleEvaluationError(error, completion: completion)
                }
                return
            }
            
            completion(.success(()))
        }
    }
    
    private func canEvaluatePolicy(_ policy: LAPolicy) -> Bool {
        context.canEvaluatePolicy(policy, error: &evaluationError)
    }
}

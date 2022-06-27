//
//  ModelEnums.swift
//  LocalAuthenticationSample
//
//  Created by Arsenii Kovalenko on 27.06.2022.
//

import Foundation
import LocalAuthentication.LAContext

enum FallBackTitle {
    case hidden
    case custom(String)
    case `default`
    
    var title: String? {
        switch self {
        case .hidden:
            return ""
        case .custom(let title):
            return title
        case .default:
            return nil
        }
    }
}

enum CancelTitle {
    case custom(String)
    case `default`
    
    var title: String? {
        switch self {
        case .custom(let title):
            return title
        case .default:
            return nil
        }
    }
}

enum TouchIDAllowableReuseDuration {
    case restricted
    case max
    case custom(TimeInterval)
    
    var duration: TimeInterval {
        switch self {
        case .restricted:
            return .zero
        case .max:
            return LATouchIDAuthenticationMaximumAllowableReuseDuration
        case .custom(let timeInterval):
            return timeInterval
        }
    }
}

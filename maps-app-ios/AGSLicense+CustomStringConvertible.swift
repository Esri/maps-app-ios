//
//  AGSLicense+CustomStringConvertible.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/25/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AGSLicense {
    open override var description: String {
        guard self.licenseType != .developer else {
            // We just return the type, since type and level would both be Developer, which is redundant
            return "\(self.licenseType)"
        }

        return "\(self.licenseLevel) [\(self.licenseType), \(self.statusAndExpiryDescription)]"
    }

    private var statusAndExpiryDescription: String {
        if let expirationDate = self.expiryNilledForLicenseLevel {
            switch self.licenseStatus {
            case .valid:
                // Valid until some time in the future…
                return "\(self.licenseStatus) Until \(expirationDate)"
            case .loginRequired:
                // Don't know what expiry is in this case, so we'll assume it's provided.
                fallthrough
            case .expired:
                // Expired some time back…
                return "\(self.licenseStatus) (Expired \(expirationDate))"
            case .invalid:
                // Not a valid license. Expiration means nothing.
                return "\(self.licenseStatus)"
            }
        } else {
            // No expiry…
            switch self.licenseStatus {
            case .valid:
                return "\(self.licenseStatus) Indefinitely"
            default:
                return "\(self.licenseStatus)"
            }
        }
    }

    private var expiryNilledForLicenseLevel: Date? {
        if self.licenseLevel == .developer && self.expiry?.timeIntervalSince1970 == 0 ||
           self.licenseLevel == .lite && (self.expiry ?? Date.distantFuture) == Date.distantFuture {
            return nil
        }
        return self.expiry
    }
}

extension AGSLicenseLevel : CustomStringConvertible {
    public var description: String {
        switch self {
        case .developer:
            return "Developer"
        case .lite:
            return "Lite"
        case .basic:
            return "Basic"
        case .standard:
            return "Standard"
        case .advanced:
            return "Advanced"
        }
    }
}

extension AGSLicenseStatus : CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalid:
            return "Invalid"
        case .valid:
            return "Valid"
        case .expired:
            return "Expired"
        case .loginRequired:
            return "Login Required"
        }
    }
}

extension AGSLicenseType : CustomStringConvertible {
    public var description: String {
        switch self {
        case .developer:
            return "Developer (not suitable for production deployment)"
        case .namedUser:
            return "Named User"
        case .licenseKey:
            return "License Key"
        }
    }
}

//
//  SecureValidation.swift
//  Kushki
//
//  Created by Marco Moreno on 26/11/20.
//
public struct SecureValidation{
    public let secureServiceId: String
    public let otpValue: String
    public let secureService: String?
    
    public init(secureServiceId: String, otpValue: String, secureService: String?) {
        self.secureServiceId = secureServiceId
        self.otpValue = otpValue
        self.secureService = secureService
    }
}

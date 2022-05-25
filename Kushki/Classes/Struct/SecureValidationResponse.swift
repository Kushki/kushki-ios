//
//  SecureValidationResponse.swift
//  Kushki
//
//  Created by Marco Moreno on 26/11/20.
//
public struct SecureValidationResponse{
    public let code: String
    public let message: String
    
    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }
    
    public func isSuccessful() -> Bool {
        return (code == "OTP000")
    }
}

//
//  NetworkError.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

struct NetworkError: Error {
    enum Code {
        case serverNotAvailable
        case logical(String)
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}

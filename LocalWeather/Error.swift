//
//  Error.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

struct LocalWeatherError {
    let code: ErrorCode
    let message: String

    let cause: Error?
    let file: String
    let line: Int

    init(code: ErrorCode, message: String, cause: Error? = nil, file: String = #file, line: Int = #line) {
        self.code = code
        self.message = message
        self.cause = cause
        self.file = file
        self.line = line
    }
}

extension LocalWeatherError: CustomStringConvertible {
    var description: String { return "\(message) in file \(file) on line \(line), cause: \(String(describing: cause))" }
}

extension LocalWeatherError: CustomNSError {
    var errorCode: Int { return code.rawValue }
    var errorUserInfo: [String : Any] {
        return [
            NSLocalizedDescriptionKey: message,
            NSUnderlyingErrorKey: cause as Any
        ]
    }
    static let errorDomain: String = "com.localweather"
}

enum ErrorCode: Int {
    case configFileNotFound = 1
    case apiKeyNotFoundInConfigFile = 2
    case invalidURL = 3
    case httpError = 4
}

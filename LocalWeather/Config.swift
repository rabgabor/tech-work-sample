//
//  Config.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

struct Config {

    let apiKey: String

    init(fileName: String = "Config.plist") throws {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            let errorMessage =
                "\n------------------------------- Warning! -------------------------------\n"
                    + "\(fileName) not found. Please, create it according to ConfigExample.plist\n"
                    + "and provide your own API key.\n"
                    + "------------------------------------------------------------------------\n"

            throw LocalWeatherError(code: .configFileNotFound,
                                    message: errorMessage,
                                    cause: nil)
        }
        let keyDictionary = NSDictionary(contentsOfFile: path)

        if let keyDictionary = keyDictionary, let apiKey = keyDictionary["apiKey"] as? String {
            self.apiKey = apiKey
        } else {
            let errorMessage =
                "\n------------------------------- Warning! -------------------------------\n"
                    + "Please, provide your own API key in \(fileName)\n"
                    + "according to ConfigExample.plist\n"
                    + "------------------------------------------------------------------------\n"

            throw LocalWeatherError(code: .apiKeyNotFoundInConfigFile,
                                    message: errorMessage,
                                    cause: nil)
        }
    }
}

//
//  WeatherByCoordinates.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

struct WeatherByCoordinatesRequest: Codable {
    let latitude: Double
    let longitude: Double
}

struct WeatherByCoordinatesResponse: Codable {
    let locationName: String
    let weather: [Weather]
    let temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case locationName = "name", weather, temperature = "main"
    }
}

extension WeatherByCoordinatesRequest: Request {
    typealias Resp = WeatherByCoordinatesResponse

    static let path = "weather"
    static let httpMethod: HTTPMethod = .get

    var query: [String : String] {
        return ["lat" : String(format:"%f", latitude),
                "lon": String(format:"%f", longitude)]
    }
}

extension WeatherByCoordinatesResponse: Response {}

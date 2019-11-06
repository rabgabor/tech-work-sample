//
//  Weather.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

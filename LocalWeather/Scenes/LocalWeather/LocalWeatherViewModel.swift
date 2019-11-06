//
//  LocalWeatherViewModel.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

class LocalWeatherViewModel {

    // MARK: - Properties

    private let webService: WebService

    // MARK: - Object lifecycle

    init(webService: WebService) {
        self.webService = webService
    }
}

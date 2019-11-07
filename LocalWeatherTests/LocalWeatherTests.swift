//
//  LocalWeatherTests.swift
//  LocalWeatherTests
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LocalWeather

class LocalWeatherTests: XCTestCase {

    func testViewModelSucceeding() {
        let localWeatherViewModel = LocalWeatherViewModel(webService: StubWebService())

        let testCoordinate = CLLocationCoordinate2D(latitude: 47.5, longitude: 19.04)
        localWeatherViewModel.fetchWeather(coordinate: testCoordinate)

        let weatherExpectation = self.expectation(description: "Weather info received")

        localWeatherViewModel.onWeatherUpdate = { weatherInfo in
            weatherExpectation.fulfill()
            XCTAssertEqual(weatherInfo.locationName, "Budapest")
            XCTAssertEqual(weatherInfo.temperature, "11º")
        }

        localWeatherViewModel.onAlert = { _, _, _ in
            XCTFail("Case should not produce error")
        }

        wait(for: [weatherExpectation], timeout: 1.5)
    }

    func testViewModelFailing() {
        let localWeatherViewModel = LocalWeatherViewModel(webService: StubWebServiceFailing())

        let testCoordinate = CLLocationCoordinate2D(latitude: 47.5, longitude: 19.04)
        localWeatherViewModel.fetchWeather(coordinate: testCoordinate)

        let errorExpectation = self.expectation(description: "Error received")

        localWeatherViewModel.onWeatherUpdate = { _ in
            XCTFail("Should not produce result")
        }

        localWeatherViewModel.onAlert = { title, message, userActions in
            errorExpectation.fulfill()
            XCTAssertEqual(title, "Networking error")
            XCTAssertEqual(message, "No internet")
            XCTAssertEqual(userActions.count, 1)
        }

        wait(for: [errorExpectation], timeout: 1.5)
    }
}

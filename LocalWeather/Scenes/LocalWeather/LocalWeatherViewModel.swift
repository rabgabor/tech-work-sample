//
//  LocalWeatherViewModel.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation
import CoreLocation

class LocalWeatherViewModel: NSObject {

    // MARK: - Properties

    var onAlert: ((_ title: String?, _ message: String, _ userActions: [UserAction]) -> Void)?
    var onOpenSettings: (() -> Void)?
    var onWeatherUpdate: ((WeatherInfo) -> Void)?

    private var timer: Timer?
    private var didFindLocation: Bool = false

    private let webService: WebService
    private let locationManager = CLLocationManager()

    // MARK: - Object lifecycle

    init(webService: WebService) {
        self.webService = webService
        super.init()

        locationManager.delegate = self
    }

    // MARK: - Interface

    func startWeatherUpdate() {
        guard timer == nil, CLLocationManager.authorizationStatus() == .authorizedWhenInUse  else {
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [weak self] _ in
            self?.didFindLocation = false
            self?.locationManager.requestLocation()
        })

        didFindLocation = false
        timer?.fire()
    }

    func stopWeatherUpdate() {
        timer?.invalidate()
        timer = nil
    }

    func fetchWeather(coordinate: CLLocationCoordinate2D) {
        webService.request(request: WeatherByCoordinateRequest(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (result) in
            guard let sureSelf = self else {
                return
            }

            switch result {
            case .success(let response):
                guard let weather = response.weather.first else {
                    DispatchQueue.main.async() {
                        sureSelf.errorAlert(title: "Server error", message: "Server did not send weather info. Shame on them.")
                    }
                    return
                }

                DispatchQueue.main.async() {
                    let weatherInfo = WeatherInfo(locationName: response.locationName,
                                                  temperature: String(format: "%.0fº", round(response.temperature.temperature)),
                                                  condition: weather.main,
                                                  description: weather.description,
                                                  iconName: weather.icon)

                    sureSelf.onWeatherUpdate?(weatherInfo)
                }
            case .failure(let error):
                DispatchQueue.main.async() {
                    sureSelf.errorAlert(title: "Networking error", message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Helper

    private func displayLocationAuthorizationPrompt() {
        var userActions = [UserAction]()

        userActions.append(UserAction(name: "Cancel",
                                      handler: { [weak self] in
                                        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                                            self?.displayLocationAuthorizationPrompt()
                                        }
        }))

        userActions.append(UserAction(name: "Open Settings",
                                      handler: { [weak self] in
                                        guard let sureSelf = self else {
                                            return
                                        }
                                        sureSelf.onOpenSettings?()
        }))

        onAlert?("Enable Location Service to check local weather",
                 "The application needs location permission to be able to check the weather at your current location.",
                 userActions)
    }

    private func errorAlert(title: String? = nil, message: String) {
        onAlert?(title, message, [UserAction(name: "OK", handler: nil)])
    }
}

extension LocalWeatherViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            stopWeatherUpdate()
        case .denied, .restricted:
            displayLocationAuthorizationPrompt()
            stopWeatherUpdate()
        case .authorizedWhenInUse:
            startWeatherUpdate()
        default:
            break
        }

        return
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // Sometimes this function is called rapidly multiple times.
        // To prevent unnecessary calls, didFindLocation ensures
        // that only the first call will be evaluated.

        guard didFindLocation == false else {
            return
        }

        if let location = locations.last {
            didFindLocation = true
            manager.stopUpdatingLocation()
            fetchWeather(coordinate: location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorAlert(title: "Location error", message: error.localizedDescription)
    }
}

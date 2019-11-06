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

    private let webService: WebService
    private let locationManager = CLLocationManager()

    // MARK: - Object lifecycle

    init(webService: WebService) {
        self.webService = webService
        super.init()

        locationManager.delegate = self
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
        case .denied, .restricted:
            displayLocationAuthorizationPrompt()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }

        return
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("SUCCESS \(location.coordinate.latitude) \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorAlert(title: "Location error", message: error.localizedDescription)
    }
}

//
//  LocalWeatherViewController.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import UIKit

class LocalWeatherViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: LocalWeatherViewModel

    // MARK: - Outlets

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // MARK: - Object lifecycle

    init?(coder: NSCoder, viewModel: LocalWeatherViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)

        setupViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyColors()
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        applyColors()
        resetInfo()
    }

    // MARK: - Setup

    private func setupViewModel() {
        viewModel.onAlert = { [weak self] title, message, userActions in
            self?.alert(title: title,
                        message: message,
                        userActions: userActions)
        }

        viewModel.onOpenSettings = {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }

        viewModel.onWeatherUpdate = { [weak self] weatherInfo in
            self?.resetInfo(with: weatherInfo)
        }
    }

    // MARK: - Helper

    private func applyColors() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark ? true : false
        iconImageView.tintColor = isDarkMode ? .white : .black
    }

    private func resetInfo(with weatherInfo: WeatherInfo? = nil) {
        if let imageName = weatherInfo?.iconName, let image = UIImage(named: imageName) {
            iconImageView.image = image
        } else {
            iconImageView.image = nil
        }

        locationNameLabel.text = weatherInfo?.locationName
        weatherDescriptionLabel.text = weatherInfo?.description
        temperatureLabel.text = weatherInfo?.temperature ?? "--º"
    }
}

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

    // MARK: - Object lifecycle

    init?(coder: NSCoder, viewModel: LocalWeatherViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)

        setupViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
}

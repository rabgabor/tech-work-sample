//
//  SceneDelegate.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    weak var localWeatherViewModel: LocalWeatherViewModel!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let config: Config
        do {
            config = try Config()
        } catch {
            print(error.localizedDescription)
            preconditionFailure(error.localizedDescription)
        }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let storyboard = UIStoryboard(name: "LocalWeather", bundle: nil)

        let viewModel = LocalWeatherViewModel(webService: LocalWeatherWebService(apiKey: config.apiKey))
        localWeatherViewModel = viewModel

        let viewController = storyboard.instantiateInitialViewController { (coder) -> LocalWeatherViewController? in
            return LocalWeatherViewController(
                coder: coder,
                viewModel: viewModel
            )
        }

        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        localWeatherViewModel.startWeatherUpdate()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localWeatherViewModel.stopWeatherUpdate()
    }
}

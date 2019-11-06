//
//  UIViewController+Alert.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String? = "",
               message: String,
               userActions: [UserAction]) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        for userAction in userActions {
            let alertAction = UIAlertAction(title: userAction.name,
                                            style: .default) { _ in
                                                userAction.handler?()
            }

            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true)
    }
}

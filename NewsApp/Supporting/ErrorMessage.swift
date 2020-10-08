//
//  ErrorMessage.swift
//  NewsApp
//
//  Created by user on 08/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class ErrorMessage {
    static func showErrorMessage(_ message: String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
            alertWindow.isHidden = true
        }))
        
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}


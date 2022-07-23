//
//  Alert.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

struct Alert {
    static func displayErrorMessage(message: String, from controller: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        controller.present(alertController, animated: true)
    }
}

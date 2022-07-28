//
//  Alert.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

extension UIViewController {
    func displayErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }
}

//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var textLabel: UILabel!

    // MARK: - Properties
    
    private var numOfTaps = 0

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func tapButton() {
        numOfTaps += 1
        textLabel.text = String(numOfTaps)
    }
    
    // MARK: - Helpers
    
    func setUpUI() {
        textLabel.text = String(numOfTaps)
    }

}


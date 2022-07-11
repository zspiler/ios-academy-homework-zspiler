//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    private var numOfTaps = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = String(numOfTaps)
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        numOfTaps += 1
        textLabel.text = String(numOfTaps)
    }
}


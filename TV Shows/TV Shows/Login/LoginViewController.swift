//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    var numOfTaps = 0;

    
    @IBAction func tapButton(_ sender: UIButton) {
        numOfTaps += 1
        textLabel.text = String(numOfTaps)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textLabel.text = String(numOfTaps)
    }
}


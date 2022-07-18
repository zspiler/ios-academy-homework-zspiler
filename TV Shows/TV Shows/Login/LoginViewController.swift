//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rememberMeCheckbox: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    // MARK: - Properties
    
    var emailText = ""
    var passwordText = ""
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func tapShowPasswordButton() {
        showPasswordButton.isSelected = !showPasswordButton.isSelected
        passwordInput.isSecureTextEntry = !showPasswordButton.isSelected
    }
    
    @IBAction func tapRememberMeCheckbox() {
        rememberMeCheckbox.isSelected = !rememberMeCheckbox.isSelected
    }
    
    @IBAction func changeEmailInputText(_ sender: UITextField) {
        emailText = sender.text ?? ""
        
        updateLoginRegisterButtons()
    }
    
    @IBAction func changePasswordInputText(_ sender: UITextField) {
        passwordText = sender.text ?? ""
        showPasswordButton.isHidden = passwordText.count == 0
        
        updateLoginRegisterButtons()
    }
    
    // MARK: - Helpers
    
    func setUpUI() {
        loginButton.layer.cornerRadius = 24
        
        rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-unselected"), for: UIControl.State.normal)
        rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-selected"), for: UIControl.State.selected)
        
        showPasswordButton.setImage(UIImage(named: "ic-visible"), for: UIControl.State.normal)
        showPasswordButton.setImage(UIImage(named: "ic-invisible"), for: UIControl.State.selected)
        
        
        let placeholderFont = UIFont.systemFont(ofSize: 17, weight: .light)
        
        emailInput.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7),
                         NSAttributedString.Key.font: placeholderFont
                        ]
        )
        
        passwordInput.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7), NSAttributedString.Key.font: placeholderFont]
        )
        
        
        disableLoginRegisterButtons()
        
    }
    
    func updateLoginRegisterButtons() {
        if emailText.count > 0 && passwordText.count > 0 {
            enableLoginRegisterButtons()
        } else {
            disableLoginRegisterButtons()
        }
    }
    
    func disableLoginRegisterButtons() {
        loginButton.tintColor = Colors.disabledLoginButtonTitle
        loginButton.backgroundColor = Colors.disabledLoginButtonBackground
        registerButton.tintColor = Colors.disabledRegisterButtonTitle
    }
    
    func enableLoginRegisterButtons() {
        loginButton.tintColor = Colors.enabledLoginButtonTitle
        loginButton.backgroundColor = Colors.enabledLoginButtonBackground
        registerButton.tintColor = Colors.enabledRegisterButtonTitle
    }
}

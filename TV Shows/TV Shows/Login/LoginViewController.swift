//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailInput: UITextField!
    @IBOutlet private weak var passwordInput: UITextField!
    @IBOutlet private weak var rememberMeCheckbox: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
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
        rememberMeCheckbox.isSelected.toggle()
    }
    
    @IBAction func changeEmailInputText() {
        updateLoginRegisterButtons()
    }
    
    @IBAction func changePasswordInputText() {
        let password = passwordInput.text ?? ""
        showPasswordButton.isHidden = password.count == 0

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
        
        
        loginButton.setTitleColor(Colors.disabledLoginButtonTitle, for: UIControl.State.disabled)
        loginButton.setTitleColor(Colors.enabledLoginButtonTitle, for: UIControl.State.normal)
        
        registerButton.setTitleColor(Colors.disabledRegisterButtonTitle, for: UIControl.State.disabled)
        registerButton.setTitleColor(Colors.enabledRegisterButtonTitle, for: UIControl.State.normal)

        disableLoginRegisterButtons()
    }
    
    func updateLoginRegisterButtons() {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        if email.count > 0 && password.count > 0 {
            enableLoginRegisterButtons()
        } else {
            disableLoginRegisterButtons()
        }
    }
    
    func disableLoginRegisterButtons() {
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        loginButton.backgroundColor = Colors.disabledLoginButtonBackground
    }
    
    func enableLoginRegisterButtons() {
        loginButton.isEnabled = true
        registerButton.isEnabled = true
        loginButton.backgroundColor = Colors.enabledLoginButtonBackground
    }
}

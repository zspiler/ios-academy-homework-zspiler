//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit
import MBProgressHUD
import Alamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailInput: UITextField!
    @IBOutlet private weak var passwordInput: UITextField!
    @IBOutlet private weak var rememberMeCheckbox: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    // MARK: - Properties
    
    private var user: User?
    
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
    
    @IBAction func tapLoginButton() {
        guard let email = emailInput.text, let password = passwordInput.text, !email.isEmpty && !password.isEmpty else { return }

        loginUser(email: email, password: password)
    }
    
    @IBAction func tapRegisterButton() {
        guard let email = emailInput.text, let password = passwordInput.text, !email.isEmpty && !password.isEmpty else { return }

        registerUser(email: email, password: password)
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
    
    func registerUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
    
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: HTTPMethod.post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                let responseHeaders = response.response?.headers.dictionary
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let userRoot):
                    self.user = userRoot.user
                    self.pushToHomeView()
                case .failure(let error):
                    print("Error creating user: \(error)")
                }
            }
    }
        
    func loginUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: HTTPMethod.post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                let responseHeaders = response.response?.headers.dictionary
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let userRoot):
                    self.user = userRoot.user
                    self.pushToHomeView()
                case .failure(let error):
                    print("Error signing in: \(error)")
                }
            }
    }
    
    func pushToHomeView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}

private struct UserResponse: Decodable {
    let user: User
}

private struct User: Codable {
    let id: String
    let email: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case imageUrl = "image_url"
    }
}
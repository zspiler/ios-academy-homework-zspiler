//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit
import MBProgressHUD


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
        showPasswordButton.isSelected.toggle()
        passwordInput.isSecureTextEntry.toggle()
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
        setUpButtons()
        setUpTextFields()
    }
    
    func setUpTextFields() {
        let placeholderFont = UIFont.systemFont(ofSize: 17, weight: .light)
        
        emailInput.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7),
                         .font: placeholderFont
            ]
        )
        
        passwordInput.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7),
                         .font: placeholderFont
            ]
        )
    }
    
    func setUpButtons() {
        rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        rememberMeCheckbox.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        
        showPasswordButton.setImage(UIImage(named: "ic-visible"), for: .normal)
        showPasswordButton.setImage(UIImage(named: "ic-invisible"), for: .selected)
        
        loginButton.layer.cornerRadius = 24
        loginButton.setTitleColor(UIColor.Button.secondary40, for: .disabled)
        loginButton.setTitleColor(UIColor.Button.primary, for: .normal)
        
        registerButton.setTitleColor(.Button.secondary40, for: .disabled)
        registerButton.setTitleColor(.Button.secondary, for: .normal)
        
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
        loginButton.backgroundColor = .Button.secondary30
    }
    
    func enableLoginRegisterButtons() {
        loginButton.isEnabled = true
        registerButton.isEnabled = true
        loginButton.backgroundColor = .Button.secondary
    }
    
    func registerUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ApiManager.session.request(AuthRouter.register(user: AuthRouter.User(email: email, password: password)))
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let userResponse):
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                case .failure(_):
                    Alert.displayErrorMessage(message: "Failed to create new account.\nPlease try again.", from: self)
                    self.registerButton.pulsate()
                }
            }
    }
    
    func loginUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ApiManager.session.request(AuthRouter.login(user: AuthRouter.User(email: email, password: password)))
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let userResponse):
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                case .failure(_):
                    Alert.displayErrorMessage(message: "Failed to sign you in.\nPlease try again.", from: self)
                    self.loginButton.pulsate()
                }
            }
    }
    
    func pushToHomeView(with user: User, authInfo: AuthInfo) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.setUserData(user: user, authInfo: authInfo)
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            Alert.displayErrorMessage(message: "Failed to sign you in.\nPlease try again.", from: self)
            self.loginButton.pulsate()
            return
        }
        if rememberMeCheckbox.isSelected {
            self.updateUserDefaults(authInfo: authInfo, user: user)
        }
        self.pushToHomeView(with: user, authInfo: authInfo)
    }
    
    func updateUserDefaults(authInfo: AuthInfo, user: User) {
        let userData = UserData(user: user, authInfo: authInfo)
        if let encodedUserData = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encodedUserData, forKey: Constants.Defaults.userData.rawValue)
        }
    }
}

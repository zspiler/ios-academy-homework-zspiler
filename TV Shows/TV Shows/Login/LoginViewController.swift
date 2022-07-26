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
            string: Constants.Strings.email,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7),
                .font: placeholderFont
            ]
        )
        
        passwordInput.attributedPlaceholder = NSAttributedString(
            string: Constants.Strings.password,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7),
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
        loginButton.setTitleColor(.Button.secondary40, for: .disabled)
        loginButton.setTitleColor(.Button.primary, for: .normal)
        
        registerButton.setTitleColor(.Button.secondary40, for: .disabled)
        registerButton.setTitleColor(.Button.secondary, for: .normal)
        
        setLoginRegisterButtons(enabled: false)
    }
    
    func updateLoginRegisterButtons() {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        
        setLoginRegisterButtons(enabled: email.count > 0 && password.count > 0)
    }
    
    func setLoginRegisterButtons(enabled: Bool) {
        loginButton.isEnabled = enabled
        registerButton.isEnabled = enabled
        loginButton.backgroundColor = enabled ? .Button.secondary : .Button.secondary30
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
                    self.displayErrorMessage(message: Constants.Error.createAccount)
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
                    self.displayErrorMessage(message: Constants.Error.login)
                }
            }
    }
    
    func pushToHomeView(with user: User, authInfo: AuthInfo) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.homeViewController) as! HomeViewController
        
        homeViewController.setUserData(user: user, authInfo: authInfo)
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            self.displayErrorMessage(message: Constants.Error.login)
            return
        }
        self.pushToHomeView(with: user, authInfo: authInfo)
    }
    
}

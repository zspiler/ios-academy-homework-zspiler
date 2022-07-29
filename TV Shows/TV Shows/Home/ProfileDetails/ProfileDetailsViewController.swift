//
//  ProfileDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2022..
//

import UIKit
import MBProgressHUD

import Alamofire

class ProfileDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var profilePhotoImageVIew: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: - Properties
    
    private var user: User?
    private var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpUI()
        fetchUserData()
    }
    
    // MARK: - Actions
    
    @IBAction func tapLogoutButton() {
        dismiss(animated: true, completion: {
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.authInfo.rawValue)
            NotificationCenter.default.post(
                Notification(
                    name: Constants.Notifications.logout,
                    object: nil,
                    userInfo: nil
                )
            )
        })
    }
    
    @IBAction func tapChangeProfilePhotoButton() {
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: - Helpers
    
    func fetchUserData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let authInfo = authInfo else { return }
        ApiManager.session.request(UserRouter.getUser(authInfo: authInfo))
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
        
                switch response.result {
                case .success(let userResponse):
                    self.displayUsersInformation(user: userResponse.user)
                case .failure:
                    self.displayErrorMessage(message: Constants.Error.user)
                }
            }
    }
    
    func uploadProfilePhoto(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9), let authInfo = authInfo
        else { return }
        
        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
      
        MBProgressHUD.showAdded(to: self.view, animated: true)
        AF
            .upload(
                multipartFormData: requestData,
                to: "https://tv-shows.infinum.academy/users",
                method: .put,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let userResponse):
                    self.setProfilePhotoSource(to: userResponse.user.imageUrl)
                case .failure:
                    self.displayErrorMessage(message: Constants.Error.profilePhotoUpload)
                }
            }
    }
    
    func setAuthenticationData(user: User?, authInfo: AuthInfo?) {
        self.user = user
        self.authInfo = authInfo
    }
    
    func displayUsersInformation(user: User) {
        emailLabel.text = user.email
        setProfilePhotoSource(to: user.imageUrl)
    }
    
    func setProfilePhotoSource(to url: URL?) {
        profilePhotoImageVIew.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic-profile-placeholder"),
            options: nil
        )
    }
     
    func setUpUI() {
        loginButton.layer.cornerRadius = 24
    
        profilePhotoImageVIew.layer.cornerRadius = profilePhotoImageVIew.frame.width / 2
        profilePhotoImageVIew.layer.masksToBounds = true
    }

    func setUpNavigationBar() {
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.Button.primary, for: .normal)
        closeButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    func popViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapBackButton() {
        popViewController()
    }
   
}

extension ProfileDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadProfilePhoto(image)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

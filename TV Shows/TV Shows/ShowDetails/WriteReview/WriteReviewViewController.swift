//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import UIKit
import MBProgressHUD

class WriteReviewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var commentTextView: UITextView!
    
    
    // MARK: - Properties
    
    var showId: String?
    var authInfo: AuthInfo?
    var userHasEditedCommentText = false
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.configure(withStyle: .large)
        ratingView.delegate = self
        commentTextView.delegate = self
        setUpNavigationBar()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func tapSubmitButton() {
        submitReview()
    }
    
    // MARK: - Helpers
    
    func submitReview() {
        guard let authInfo = authInfo, let showId = showId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let review = NewReview(rating: ratingView.rating, showId: Int(showId)!, comment: commentTextView.text)
        
        ApiManager.session.request(ReviewsRouter.create(authInfo: authInfo, review: review))
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success:
                    self.popViewController()
                case .failure:
                    Alert.displayErrorMessage(message: "Failed to create review.", from: self)
                }
            }
    }
    
    func setUpUI() {
        commentTextView.textColor = UIColor.black.withAlphaComponent(0.5)
        submitButton.layer.cornerRadius = 24
        disableSubmitButton()
    }
    
    func disableSubmitButton() {
        submitButton.isEnabled = false
        submitButton.alpha = 0.2
    }
    
    func enableSubmitButton() {
        submitButton.isEnabled = true
        submitButton.alpha = 1
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "Write a Review"
        addBackButtonToNavigationBar()
    }
    
    func addBackButtonToNavigationBar() {
        let backButton = UIButton()
        backButton.tintColor = .white
        backButton.setTitle("Close", for: .normal)
        backButton.setTitleColor(UIColor.Button.primary, for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapBackButton() {
        popViewController()
    }
    
    func validateInputs() {
        if !userHasEditedCommentText || ratingView.rating == 0 || commentTextView.text.isEmpty {
            disableSubmitButton()
        } else {
            enableSubmitButton()
        }
    }
}

extension WriteReviewViewController: UITextViewDelegate {
    
    func textViewDidChange(_ _: UITextView) {
        validateInputs()
    }
    
    func textViewDidBeginEditing(_ _: UITextView) {
        commentTextView.textColor = UIColor.black
        commentTextView.text = ""
        userHasEditedCommentText = true
    }
    
  
}

extension WriteReviewViewController: RatingViewDelegate {
    func didChangeRating(_ rating: Int) {
        validateInputs()
    }
}

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
    
    private var showId: String?
    private var authInfo: AuthInfo?
    private var userHasEditedCommentText = false
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func tapSubmitButton() {
        submitReview()
    }
    
    // MARK: - Helpers
    
    func setAuthenticationAndShowData(showId: String?, authInfo: AuthInfo?) {
        self.showId = showId
        self.authInfo = authInfo
    }
    
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
                    self.displayErrorMessage(message: "Failed to create review.")
                }
            }
    }
    
    func setUpUI() {
        ratingView.configure(withStyle: .large)
        ratingView.delegate = self
        
        commentTextView.delegate = self
        commentTextView.textColor = UIColor.black.withAlphaComponent(0.5)
        commentTextView.layer.cornerRadius = 10
        
        submitButton.layer.cornerRadius = 24
        setSubmitButton(enabled: false)
    }
    
    func setSubmitButton(enabled: Bool) {
        submitButton.isEnabled = enabled
        submitButton.alpha = enabled ? 1 : 0.2
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Write a Review"
        addCloseButtonToNavigationBar()
    }
    
    func addCloseButtonToNavigationBar() {
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
    
    func validateInputs() {
        if !userHasEditedCommentText || ratingView.rating == 0 || commentTextView.text.isEmpty {
            setSubmitButton(enabled: false)
        } else {
            setSubmitButton(enabled: true)
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

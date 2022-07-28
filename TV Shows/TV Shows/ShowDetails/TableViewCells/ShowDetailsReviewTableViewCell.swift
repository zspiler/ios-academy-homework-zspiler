//
//  ShowDetailsReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import UIKit

class ShowDetailsReviewTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var ratingStarsStackView: UIStackView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
}


// MARK: - Configure

extension ShowDetailsReviewTableViewCell {

    func configure(with review: Review) {
        profilePictureImageView.image = UIImage(named: "ic-profile-placeholder")
        
        commentLabel.text = review.comment
        emailLabel.text = review.user.email
        
        configureRatingStarIcons(with: review)
        configureImageView(with: review)
    }
    
    private func configureImageView(with review: Review) {
        profilePictureImageView.kf.setImage(
            with: review.user.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"),
            options: nil
        )
    }
    
    private func configureRatingStarIcons(with review: Review) {
        let starIcons = ratingStarsStackView.arrangedSubviews as! [UIImageView]
        starIcons.enumerated().forEach { index, element in
            if review.rating < index + 1 {
                element.image = UIImage(named: "ic-star-deselected")
            }
        }
    }
}

private extension ShowDetailsReviewTableViewCell {

    func setUpUI() {
        self.isUserInteractionEnabled = false
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.layer.masksToBounds = true
    }
}


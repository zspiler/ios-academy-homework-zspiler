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
}


// MARK: - Configure

extension ShowDetailsReviewTableViewCell {

    func configure(with review: Review) {
        self.isUserInteractionEnabled = false
        profilePictureImageView.image = UIImage(named: "ic-profile-placeholder")

        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.layer.masksToBounds = true
        
        commentLabel.text = review.comment
        emailLabel.text = review.user.email
        
    }
}


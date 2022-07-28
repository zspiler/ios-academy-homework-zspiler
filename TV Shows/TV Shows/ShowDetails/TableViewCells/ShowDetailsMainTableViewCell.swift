//
//  ShowDetailsMainTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import Kingfisher

class ShowDetailsMainTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var showCoverImageView: UIImageView!
    @IBOutlet private weak var reviewStatsDescriptionLabel: UILabel!
    @IBOutlet private weak var avgRatingStarsStackView: UIStackView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
}

// MARK: - Configure

extension ShowDetailsMainTableViewCell {
    
    func configure(with show: Show?) {
        guard let show = show else { return }
        configureImageView(with: show)
        configureLabels(with: show)
        configureAvgRatingStarIcons(with: show)
    }
    
    private func configureImageView(with show: Show) {
        showCoverImageView.kf.setImage(
            with: show.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"),
            options: nil
        )
    }
    
    private func configureLabels(with show: Show) {
        showDescriptionLabel.text = show.description
        
        guard let averageRating = show.averageRating else { return }
        let roundedAvgRating = (averageRating * 100).rounded() / 100
        reviewStatsDescriptionLabel.text = "\(String(show.numberOfReviews)) REVIEWS, \(String(roundedAvgRating)) AVERAGE"
    }
    
    private func configureAvgRatingStarIcons(with show: Show) {
        guard let averageRating = show.averageRating else { return }
        
        let starIcons = avgRatingStarsStackView.arrangedSubviews as! [UIImageView]
        starIcons.enumerated().forEach { index, element in
            if averageRating < Double(index + 1) {
                element.image = UIImage(named: "ic-star-deselected")
            }
        }
    }
}

private extension ShowDetailsMainTableViewCell {
    
    func setUpUI() {
        self.isUserInteractionEnabled = false
        showCoverImageView.layer.cornerRadius = 10
        showCoverImageView.layer.masksToBounds = true
    }
}


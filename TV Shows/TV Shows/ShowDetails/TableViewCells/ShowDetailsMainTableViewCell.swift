//
//  ShowDetailsMainTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

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
    
    func configure(with show: Show) {
        configureImageView(with: show)
        configureLabels(with: show)
        configureAvgRatingStarIcons(with: show)
    }
    
    private func configureImageView(with show: Show) {
        showCoverImageView.image = UIImage(named: "ic-show-placeholder-rectangle")
    }
    
    private func configureLabels(with show: Show) {
        showDescriptionLabel.text = show.description
        
        guard let averageRating = show.averageRating else { return }
        let roundedAvgRating = (averageRating * 100).rounded() / 100
        reviewStatsDescriptionLabel.text = "\(String(show.numOfReviews)) REVIEWS, \(String(roundedAvgRating)) AVERAGE"
    }
    
    private func configureAvgRatingStarIcons(with show: Show) {
        guard let averageRating = show.averageRating else { return }
        
        let starIcons = avgRatingStarsStackView.arrangedSubviews as! [UIImageView]
        for (index, element) in starIcons.enumerated() {
            if averageRating < Double(index + 1) {
                element.image = UIImage(named: "ic-star-deselected")
            }
        }
    }
}

private extension ShowDetailsMainTableViewCell {
    
    func setUpUI() {
        self.isUserInteractionEnabled = false
        showCoverImageView.layer.cornerRadius = 20
        showCoverImageView.layer.masksToBounds = true
    }
}


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
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

// MARK: - Configure

extension ShowDetailsMainTableViewCell {

    func configure(with show: Show) {
        self.isUserInteractionEnabled = false
        showCoverImageView.image = UIImage(named: "ic-show-placeholder-rectangle") 
        showCoverImageView.layer.cornerRadius = 20
        showCoverImageView.layer.masksToBounds = true

        showDescriptionLabel.text = show.description
    }
}

//
//  ShowsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import Kingfisher

class ShowsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
       
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var showImageView: UIImageView!
    
    // MARK: - Configure
   
    func configure(with show: Show) {
        titleLabel.text = show.title
        
        showImageView.kf.setImage(
            with: show.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-vertical"),
            options: nil
        )
    }
}

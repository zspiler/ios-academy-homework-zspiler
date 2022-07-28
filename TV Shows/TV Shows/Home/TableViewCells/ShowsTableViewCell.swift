//
//  ShowsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

class ShowsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(with show: Show) {
        titleLabel.text = show.title
    }
}

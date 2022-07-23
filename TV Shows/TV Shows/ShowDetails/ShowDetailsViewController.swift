//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var show: Show?
    var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        showTitleLabel.text = show?.title
        setUpTableView()
    }
    
    // MARK: - Helpers
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ShowDetailsMainTableViewCell", bundle: nil), forCellReuseIdentifier: "showDetailsMainCell")
    }

}



extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "showDetailsMainCell", for: indexPath) as! ShowDetailsMainTableViewCell
        mainCell.showDescriptionLabel.text = show?.description ?? ""
        return mainCell
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 600
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: prevent selection of cell 1?
    }
}


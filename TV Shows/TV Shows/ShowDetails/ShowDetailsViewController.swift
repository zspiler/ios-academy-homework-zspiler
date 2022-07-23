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
   
//        tableView.estimatedRowHeight = 300
    }

}



extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: "Cell",
//            for: indexPath) as! AuteurTableViewCell
//          let auteur = auteurs[indexPath.row]
//          cell.bioLabel.text = auteur.bio
//          cell.bioLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailsMainCell", for: indexPath) as! ShowDetailsMainTableViewCell

        cell.showDescriptionLabel.text = show?.description!
  
        
        return cell
    }

}

extension ShowDetailsViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
////        return 500
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: prevent selection of cell 1?
    }
}


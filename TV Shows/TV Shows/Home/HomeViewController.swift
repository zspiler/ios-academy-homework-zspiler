//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2022..
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var user: User?
    var authInfo: AuthInfo?
    var shows: [Show] = []
    var page = 1
    var numberOfPages: Int?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setViewControllers([self], animated: true)
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchShows()
    }
    
    // MARK: - Helpers
    
    func fetchShows() {
        guard let authInfo = authInfo else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ApiManager.session.request(ShowsRouter.getAll(authInfo: authInfo, pageNumber: page))
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let showsResponse):
                    self.shows.append(contentsOf: showsResponse.shows)
                    self.numberOfPages = self.numberOfPages ?? showsResponse.meta.pagination.pages
                    self.page = showsResponse.meta.pagination.page + 1
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    Alert.displayErrorMessage(message: "Failed to fetch shows.", from: self)
                }
            }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowsTableViewCell.self), for: indexPath) as! ShowsTableViewCell
        cell.titleLabel.text = shows[indexPath.row].title
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.authInfo = authInfo
        showDetailsViewController.show = shows[indexPath.row]
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let numberOfPages = numberOfPages else { return }
        if indexPath.row == shows.count - 1 && page - 1 < numberOfPages {
            fetchShows()
        }
    }
    
}

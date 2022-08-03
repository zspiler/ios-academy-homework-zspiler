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
    
    private var authInfo: AuthInfo?
    private var shows: [Show] = []
    private var page = 1
    private var numberOfPages: Int?
    private var notificationToken: NSObjectProtocol?

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewAndNavController()
        fetchShows()
        setUpNavigationBar()
        addNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(notificationToken!)
    }
    
    // MARK: - Helpers
    
    func setAuthInfo(_ authInfo: AuthInfo) {
        self.authInfo = authInfo
    }

    func setUpTableViewAndNavController() {
        navigationController?.setViewControllers([self], animated: true)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
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
                case .failure:
                    self.displayErrorMessage(message: Constants.Error.fetchShows)
                }
            }
    }
    
    func updateShowsTableView(using showsResponse: ShowsResponse) {
        self.shows.append(contentsOf: showsResponse.shows)
        self.numberOfPages = self.numberOfPages ?? showsResponse.meta.pagination.pages
        self.page = showsResponse.meta.pagination.page + 1
        self.tableView.reloadData()
    }

    func setUpNavigationBar() {
        let profileDetailsItem = UIBarButtonItem(
                image: UIImage(named: "ic-profile"),
                style: .plain,
                target: self,
                action: #selector(tapProfileButton)
              )
        profileDetailsItem.tintColor = UIColor.Button.primary
        navigationItem.rightBarButtonItem = profileDetailsItem
    }
    
    @objc func tapProfileButton() {
        presentProfileScreen()
    }
    
    func presentProfileScreen() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.profileDetails, bundle: nil)
        let profileDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.profileDetails) as! ProfileDetailsViewController
        profileDetailsViewController.setAuthInfo(authInfo)
        let navigationController = UINavigationController(rootViewController: profileDetailsViewController)
        present(navigationController, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowsTableViewCell.self), for: indexPath) as! ShowsTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.showDetails) as! ShowDetailsViewController
        showDetailsViewController.setAuthInfo(authInfo)
        showDetailsViewController.setShow(shows[indexPath.row])
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let numberOfPages = numberOfPages else { return }
        if indexPath.row == shows.count - 1 && page - 1 < numberOfPages {
            fetchShows()
        }
    }
    
    func addNotificationObserver() {
        notificationToken = NotificationCenter
            .default
            .addObserver(
                forName: Constants.Notifications.logout,
                object: nil,
                queue: nil,
                using: { _ in
                    self.resetNavigationStack()
                }
            )
    }
    
    func resetNavigationStack() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.login, bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.login) as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
}

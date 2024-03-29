//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import MBProgressHUD

class ShowDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    
    // MARK: - Properties
    
    private var show: Show?
    private var authInfo: AuthInfo?
    private var reviews: [Review] = []
    private var page = 1
    private var numberOfPages: Int?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchReviews()
        setUpTableView()
    }
    
    // MARK: - Actions
    
    @IBAction func tapWriteReviewButton() {
        presentWriteReviewScreen()
    }
    
    // MARK: - Helpers
    
    func setShow(_ show: Show?) {
        self.show = show
    }
    
    func setAuthInfo(_ authInfo: AuthInfo?) {
        self.authInfo = authInfo
    }
    
    func setUpUI() {
        showTitleLabel.text = show?.title
        writeReviewButton.layer.cornerRadius = 24
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchReviews() {
        guard let authInfo = authInfo else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)

        ApiManager.session.request(ReviewsRouter.getAll(authInfo: authInfo, showId: show!.id, pageNumber: page))
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let reviewsResponse):
                    self.updateReviewsTableView(using: reviewsResponse)
                case .failure:
                    self.displayErrorMessage(message: Constants.Error.fetchReviews)
                }
            }
    }
    
    func updateReviewsTableView(using reviewsResponse: ReviewsResponse) {
        self.reviews.append(contentsOf: reviewsResponse.reviews)
        self.numberOfPages = self.numberOfPages ?? reviewsResponse.meta.pagination.pages
        self.page = reviewsResponse.meta.pagination.page + 1
        self.tableView.reloadData()
    }
    
    func presentWriteReviewScreen() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.writeReview, bundle: nil)
        let writeReviewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.writeReview) as! WriteReviewViewController
        writeReviewController.setAuthenticationAndShowData(showId: show?.id, authInfo: authInfo)

        let navigationController = UINavigationController(rootViewController: writeReviewController)
        present(navigationController, animated: true)
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailsMainCell", for: indexPath) as! ShowDetailsMainTableViewCell
            cell.configure(with: show)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailsReviewCell", for: indexPath) as! ShowDetailsReviewTableViewCell
            cell.configure(with: reviews[indexPath.row - 1])
            return cell
        }

    }

}

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let numberOfPages = numberOfPages else { return }
        let reviewIndex = indexPath.row + 1
        if reviewIndex == reviews.count - 1 && page - 1 < numberOfPages {
            fetchReviews()
        }
    }
}

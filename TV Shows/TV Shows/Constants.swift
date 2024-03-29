//
//  Constants.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2022..
//

import Foundation

enum Constants {

    enum Defaults: String {
        case authInfo
    }
    
    enum Networking {
        static let apiBaseUrl = "https://tv-shows.infinum.academy/"
    }
    
    enum Strings {
        static let email = "Email"
        static let password = "Password"   
    }
    
    enum Error {
        static let createAccount = "Failed to create new account.\nPlease try again."
        static let login = "Failed to sign you in.\nPlease try again."
        static let fetchShows = "Failed to fetch shows."
        static let fetchReviews = "Failed to fetch reviews."
        static let user = "Failed to fetch information about user."
        static let profilePhotoUpload = "Failed to upload photo."
        static let logout = "Failed to log out."
    }
    
    enum Storyboards {
        static let home = "Home"
        static let login = "Login"
        static let writeReview = "WriteReview"
        static let profileDetails = "ProfileDetails"
        static let showDetails = "ShowDetails"
    }
    
    enum ViewControllers {
        static let home = "HomeViewController"
        static let writeReview = "WriteReviewViewController"
        static let profileDetails = "ProfileDetailsViewController"
        static let login = "LoginViewController"
        static let showDetails = "ShowDetailsViewController"
    }
    
    enum Notifications {
        static let logout = Notification.Name(rawValue: "Logout")
    }
    
}

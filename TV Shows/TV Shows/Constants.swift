//
//  Constants.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2022..
//

import Foundation

enum Constants {
    
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
    }
    
    enum Storyboards {
        static let home = "Home"
    }
    
    enum ViewControllers {
        static let homeViewController = "HomeViewController"
    }
    
}

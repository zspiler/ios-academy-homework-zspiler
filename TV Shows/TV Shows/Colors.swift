//
//  Colors.swift
//  TV Shows
//
//  Created by Infinum on 16.07.2022..
//

import UIKit

extension UIColor {
    enum Button {
        static var secondary: UIColor {
            return UIColor(named: "secondary")!
        }
        
        static var secondary30: UIColor {
            return UIColor(named: "secondary30")!
        }
        
        static var secondary40: UIColor {
            return UIColor(named: "secondary40")!
        }
        
        static var primary: UIColor {
            return UIColor(named: "primary")!
        }
    }
    
    enum NavigationBar {
        static var background: UIColor {
            return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.94)
        }
    }
}

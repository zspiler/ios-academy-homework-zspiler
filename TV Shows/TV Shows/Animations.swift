//
//  Animations.swift
//  TV Shows
//
//  Created by Infinum on 26.07.2022..
//

import UIKit


extension UIView {

    func pulsate() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.autoreverse]) {
                self.transform = CGAffineTransform(
                    scaleX: 0.89,
                    y: 1
                )

            } completion: { _ in
                self.transform = .identity
            }
    }
    
}

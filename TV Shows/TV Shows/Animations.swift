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
            options: [.curveEaseInOut]) {
                self.transform = CGAffineTransform(
                    scaleX: 0.89,
                    y: 1
                )
            } completion: { _ in
                UIView.animate(
                    withDuration: 0.15,
                    delay: 0,
                    options: [.curveEaseInOut]) {
                        self.transform =  CGAffineTransform(
                            scaleX: 1,
                            y: 1
                        )
                    }
            }
    }
    
}

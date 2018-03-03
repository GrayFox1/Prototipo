//
//  CustomTabBarViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 03/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundImage = UIImage.customImage(with: .clear)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = self.tabBar.bounds
        self.tabBar.insertSubview(frost, at: 0)
        
    }
    
}

extension UIImage {
    class func customImage(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

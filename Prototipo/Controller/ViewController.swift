//
//  ViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 16/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller não existe")}

        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(FlatBlack(), returnFlat: true)]
        
    }
    

}


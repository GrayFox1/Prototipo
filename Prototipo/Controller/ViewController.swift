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
        let colorHex = FlatWhite().hexValue()
        updateNavBar(withHexCode: colorHex)
    }
    
    func updateNavBar(withHexCode colorHexCode : String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller não existe")}
        guard let navBarColor = UIColor(hexString : colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
    }

}


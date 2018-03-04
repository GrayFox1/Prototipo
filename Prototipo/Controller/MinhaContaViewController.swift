//
//  MinhaContaViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 02/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase

class MinhaContaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func logOutAction(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToIntroView", sender: self)
        }
        catch{
            print("Erro ao deslogar")
        }
    }
    


}

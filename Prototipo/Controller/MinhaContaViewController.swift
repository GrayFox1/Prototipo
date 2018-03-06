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
    
    var newClient : Client?

    
    @IBOutlet weak var dadosLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dados = newClient{
            dadosLabel.text = "Nome: \(dados.nome)\nGênero: \(dados.genero)\nData Nascimento: \(dados.dataNasc) "
        }
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

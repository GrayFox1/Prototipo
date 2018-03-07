//
//  InfoViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 01/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var productIndex : Int = 0
    var infos = ["Em caso de afastamento temporário do trabalho, causado por acidente ou doença cobertos pelo plano, você receberá uma Diária por Incapacidade Temporária (DIT) para manutenção do seu padrão de vida.", "Descrição do produto B", "Descrição do produto C", "Descrição do produto D", "Descrição do produto E", "Descrição do produto F"]
    
    @IBOutlet weak var textInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInfo.text = infos[productIndex]
        
    }
}

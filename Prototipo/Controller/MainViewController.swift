//
//  MainViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 01/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainViewController: UIViewController {
    
    var newClient : Client?
    let empresaImages = ["empresa1", "empresa2", "empresa3"]
    var updateCounter = 0
    var timer : Timer?

    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoImage.image = UIImage(named: "empresa1")
        updateCounter = 0
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var temp = newClient?.nome.components(separatedBy: " ")
        let userName = temp?.removeFirst() ?? "Falha na rede"
        nameLabel.text = userName
        
        if(newClient?.genero == "Feminino"){
            welcomeLabel.text = "Seja bem-vinda! :)"
        }
        else{
            welcomeLabel.text = "Seja bem-vindo! :)"
        }
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller não existe")}
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(UIColor.black, returnFlat: true)]
        
        
    }
    
    @objc func updateTimer(){
        
        if(updateCounter < 2){
            updateCounter += 1
        }
        else{
            updateCounter = 0
        }
        infoImage.image = UIImage(named: empresaImages[updateCounter])
        pageControl.currentPage = updateCounter
    }
    
    
    @IBAction func verFavoritosAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToMeusProdutosView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMeusProdutosView"){
            let destinationVC = segue.destination as! MeusProdutosViewController
            destinationVC.client = self.newClient
        }
    }
    
    
}

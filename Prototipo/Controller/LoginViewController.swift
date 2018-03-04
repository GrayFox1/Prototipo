//
//  LoginViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 17/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    var errorCode : Int = 0
    var newClient = Client()

    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var senhaTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextInput.text!, password: senhaTextInput.text!) {
            (user, error) in
            
            if(error != nil){
                print(error!)
                SVProgressHUD.dismiss()
                self.showAlert(code : self.errorCode)
                
                if(error.debugDescription.contains("17008")){
                    self.errorCode = 17008  //E-mail inválido
                }
                else if(error.debugDescription.contains("17009")){
                    self.errorCode = 17009  //Senha inválida
                }
                else if(error.debugDescription.contains("17011")){
                    self.errorCode = 17011  //User não existe
                }
                
            }
            else{
                self.retrieveClientData()
                SVProgressHUD.dismiss()
                print("Login concluído!")
            }
        }
    }
    
    func retrieveClientData(){
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Clientes").child(userID!)

        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            let data = snapshot.value as? NSDictionary
            
            self.newClient.nome = data?["Nome"] as! String
            self.newClient.fumante = data?["Fumante"] as! String
            self.newClient.praticaEsporte = data?["PraticaEsporte"] as! String
            self.newClient.idade = Int(data?["Idade"] as! String)!
            let temp = NSMutableArray(array: data?["Produtos Selecionados"] as! [String])
            self.newClient.produtosSelected = temp as! [String]
            
            self.performSegue(withIdentifier: "goToTabView", sender: self)
        }

    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToTabView"){
            let destinationBVC = segue.destination as! UITabBarController
            let destinationNVC = destinationBVC.viewControllers![0] as! UINavigationController
            let destinationVC = destinationNVC.topViewController as! MainViewController
            destinationVC.newClient = self.newClient
        }
    }
    
    func showAlert(code : Int){
        
        var alert = UIAlertController(title: "E-mail ou senha inválido 😢", message: "", preferredStyle: .alert)
        
        if(code == 17009){
            alert = UIAlertController(title: "Senha inválida! 😥", message: "", preferredStyle: .alert)
        }
        else if(code == 17008){
            alert = UIAlertController(title: "E-mail inválido! 😭", message: "", preferredStyle: .alert)
        }
        else if(code == 17011){
            alert = UIAlertController(title: "Usuário não existe! 😥", message: "", preferredStyle: .alert)
        }
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.emailTextInput.text = ""
            self.senhaTextInput.text = ""
        })
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    

}

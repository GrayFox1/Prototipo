//
//  RegisterViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 17/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    var newClient : Client?
    var clientHKData = [String : String]()
    var errorCode : Int = 0

    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var senhaTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextInput.text!, password: senhaTextInput.text!) {
            (user, error) in
            
            if ( error != nil) {
                print(error.debugDescription)

                if(error.debugDescription.contains("17008")){
                    self.errorCode = 17008  //E-mail inválido
                }
                else if(error.debugDescription.contains("17007")){
                    self.errorCode = 17007  //User já existe
                }
                else if(error.debugDescription.contains("17026")){
                    self.errorCode = 17026  //Senha fraca
                }
                SVProgressHUD.dismiss()
                self.showAlert(code : self.errorCode)
            }
            else{
                SVProgressHUD.dismiss()
                print("Cadastro concluído!")
                if(self.newClient == nil){
                    self.performSegue(withIdentifier: "goToCreditsView", sender: self)
                }
                else{
                    self.writeBD()
                    self.performSegue(withIdentifier: "goToTabView", sender: self)
                }
            }
        }
    }
    
    func showAlert(code : Int){
        
        var alert = UIAlertController(title: "E-mail ou senha inválido 😢", message: "A senha deve conter no mínimo 6 caracteres", preferredStyle: .alert)
        
        if(code == 17007){
            alert = UIAlertController(title: "Usuário já cadastrado! 😥", message: "Caso seja você, faça login :)", preferredStyle: .alert)
        }
        else if(code == 17008){
            alert = UIAlertController(title: "E-mail inválido! 😢", message: "", preferredStyle: .alert)
        }
        else if(code == 17026){
            alert = UIAlertController(title: "Senha inválida! 😭", message: "A senha deve conter no mínimo 6 caracteres", preferredStyle: .alert)
        }
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.emailTextInput.text = ""
            self.senhaTextInput.text = ""
        })
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToTabView"){
            let destinationBVC = segue.destination as! UITabBarController
            let destinationNVC = destinationBVC.viewControllers![0] as! UINavigationController
            let destinationVC = destinationNVC.topViewController as! MainViewController
            destinationVC.newClient = self.newClient
            
            let destinationVC2 = destinationBVC.viewControllers![1] as! MinhaContaViewController
            destinationVC2.newClient = self.newClient
        }
    }
    
    func writeBD(){
        let ref = Database.database().reference().child("Clientes")
        let clientData = ["Email" : Auth.auth().currentUser?.email, "Nome" : newClient?.nome, "Gênero" : newClient?.genero, "Data Nascimento" : newClient?.dataNasc, "PraticaEsporte" : newClient?.praticaEsporte , "Fumante" : newClient?.fumante]
        
        SVProgressHUD.show()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child(userID!).setValue(clientData) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                print("New client data saved successfully Part 1!")
            }
            
        }
        
        ref.child(userID!).child("Health Data").setValue(clientHKData) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                print("New client data saved successfully Part 1.5!")
            }
            
        }
        
        ref.child(userID!).child("Produtos Selecionados").setValue(newClient?.produtosSelected) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                SVProgressHUD.dismiss()
                print("New client data saved successfully Part 2!")
            }
            
        }
    }

}

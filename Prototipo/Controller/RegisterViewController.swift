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

    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var senhaTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextInput.text!, password: senhaTextInput.text!) {
            (user, error) in
            
            if ( error != nil) {
                print(error!)
                SVProgressHUD.dismiss()
                self.showAlert()
            }
            else{
                SVProgressHUD.dismiss()
                print("Cadastro concluído!")
                if(self.newClient == nil){
                    self.performSegue(withIdentifier: "goToCreditsView", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "goToTabView", sender: self)
                }
            }
        }
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "E-mail ou senha inválido 😢", message: "A senha deve conter no mínimo 6 caracteres", preferredStyle: .alert)
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
        }
    }

}

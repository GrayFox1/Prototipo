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
                self.performSegue(withIdentifier: "goToQuestionsView", sender: self)
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
        
        DispatchQueue.main.async {
            self.emailTextInput.resignFirstResponder()
            self.senhaTextInput.resignFirstResponder()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

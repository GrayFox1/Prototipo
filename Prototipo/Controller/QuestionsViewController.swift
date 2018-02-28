//
//  QuestionsViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 17/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class QuestionsViewController: UIViewController {
    
    var questionNum : Int = 0
    let questionsArray : [String] = ["Qual é o seu nome?", "Quantos anos você tem?", "Você pratica esportes?", "Você fuma?"]
    let newClient = Client()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        welcomeLabel.isHidden = true
        button1.isHidden = true
        button2.isHidden = true
        nextQuestion()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProdutosViewController
        destinationVC.newClient = self.newClient
        
    }
    
    func nextQuestion (){
        
        if(questionNum < questionsArray.count){
            questionLabel.text = questionsArray[questionNum]
            updateView()
        }
        else{
            if(Auth.auth().currentUser?.email != nil){ // Possui login
                writeBD()
            }
            else{
                performSegue(withIdentifier: "goToProdutosView", sender: self)
            }
        }
    }
    
    func writeBD(){
        let messagesBD = Database.database().reference().child("Clientes")
        let clientData = ["Email" : Auth.auth().currentUser?.email, "Nome" : newClient.nome, "Idade" : String(newClient.idade), "PraticaEsporte" : newClient.praticaEsporte , "Fumante" : newClient.fumante ]
        
        SVProgressHUD.show()
        
        messagesBD.childByAutoId().setValue(clientData) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                SVProgressHUD.dismiss()
                print("New client data saved successfully!")
                self.performSegue(withIdentifier: "goToProdutosView", sender: self)
        
            }
            
        }
        
    }
    
    func updateView (){
        answerTextInput.text = ""
        progressLabel.text = "\(questionNum + 1) / \(questionsArray.count)"
        progressBar.frame.size.width = (view.frame.size.width / 4 ) * CGFloat(questionNum + 1)
        
        if(questionNum == 1){
            welcomeLabel.text = "Seja bem-vinda \(newClient.nome)!😃"
            welcomeLabel.isHidden = false
        }
        else if(questionNum == 2){
            button1.isHidden = false
            button2.isHidden = false
            sendButton.isHidden = true
            answerTextInput.isHidden = true
        }
    }
    
    @IBAction func enviarAction(_ sender: UIButton) {
        
        let result = checkAnswer()
        
        if(result == true){
            switch(questionNum){
                
            case 0:
                newClient.nome = answerTextInput.text!
            case 1:
                newClient.idade = Int(answerTextInput.text!)!
            default:
                print("QuestionNum Invalido")
            
            }
            questionNum += 1
            nextQuestion()
        }
        else{
            showAlert()
        }
        
    }
    
    func checkAnswer () -> Bool{
        let resp = answerTextInput.text
        
        if(questionNum == 0){
            return true
        }
        else if(questionNum == 1){
            let idade = Int(resp!)!
            if (idade >= 10 && idade <= 100){
                return true
            }
        }
        else if(questionNum > 1){
            return true
        }
        
        return false
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Resposta inválida 😭", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.answerTextInput.text = ""
        })
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        
        if(questionNum == 2 && sender.tag == 1){
            newClient.praticaEsporte = "Sim"
        }
        else if(questionNum == 2 && sender.tag == 2){
            newClient.praticaEsporte = "Não"
        }
        else if(questionNum == 3 && sender.tag == 1){
            newClient.fumante = "Sim"
        }
        else if(questionNum == 3 && sender.tag == 2){
            newClient.fumante = "Não"
        }
        
        questionNum += 1
        nextQuestion()
        
    }

}

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
    let questionsArray : [String] = ["Qual é o seu nome?", "Gênero?", "Qual é sua data de nascimento?", "Você pratica esportes?", "Você fuma?"]
    let newClient = Client()
    
    
    @IBOutlet weak var buttonF: UIButton!
    @IBOutlet weak var buttonM: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        datePicker.isHidden = true
        welcomeLabel.isHidden = true
        button1.isHidden = true
        button2.isHidden = true
        buttonM.isHidden = true
        buttonF.isHidden = true
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
            if let user = Auth.auth().currentUser {
                print("Email: " + (user.email!))
                writeBD()
            }
            else{
                performSegue(withIdentifier: "goToProdutosView", sender: self)
            }
        }
    }
    
    func writeBD(){
        let ref = Database.database().reference().child("Clientes")
        let clientData = ["Email" : Auth.auth().currentUser?.email, "Nome" : newClient.nome, "Gênero" : newClient.genero, "Data Nascimento" : newClient.dataNasc, "PraticaEsporte" : newClient.praticaEsporte , "Fumante" : newClient.fumante ]
        
        SVProgressHUD.show()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child(userID!).setValue(clientData) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                SVProgressHUD.dismiss()
                print("New client data saved successfully Part 1!")
                self.performSegue(withIdentifier: "goToProdutosView", sender: self)
        
            }
            
        }
        
    }
    
    func updateView (){
        answerTextInput.text = ""

        progressBar.frame.size.width = (view.frame.size.width / 5 ) * CGFloat(questionNum + 1)
        
        if(questionNum == 1){  // Gênero
            sendButton.isHidden = true
            answerTextInput.isHidden = true
            buttonM.isHidden = false
            buttonF.isHidden = false
        }
        else if(questionNum == 2){  // Data Nasc
            var temp = newClient.nome.components(separatedBy: " ")
            let userName = temp.removeFirst()
            
            if(newClient.genero == "Feminino"){
                welcomeLabel.text = "Seja bem-vinda \(userName)!😃"
            }
            else{
                welcomeLabel.text = "Seja bem-vindo \(userName)!😃"
            }
            
            sendButton.isHidden = false
            buttonM.isHidden = true
            buttonF.isHidden = true
            welcomeLabel.isHidden = false
            datePicker.isHidden = false
        }
        else if(questionNum == 3){  // Esporte e fumante
            datePicker.isHidden = true
            button1.isHidden = false
            button2.isHidden = false
            sendButton.isHidden = true
        }
    }
    
    @IBAction func enviarAction(_ sender: UIButton) {
        
        let result = checkAnswer()
        
        if(result == true){
            switch(questionNum){
                
            case 0:
                newClient.nome = answerTextInput.text!
            case 2:
                newClient.dataNasc = getDate()
                print("Data Nascimento: " + newClient.dataNasc)
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
            if(resp!.count > 1){
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
        
        if(questionNum == 1 && sender.tag == 3){
            newClient.genero = "Masculino"
        }
        else if(questionNum == 1 && sender.tag == 4){
            newClient.genero = "Feminino"
        }
        else if(questionNum == 3 && sender.tag == 1){
            newClient.praticaEsporte = "Sim"
        }
        else if(questionNum == 3 && sender.tag == 2){
            newClient.praticaEsporte = "Não"
        }
        else if(questionNum == 4 && sender.tag == 1){
            newClient.fumante = "Sim"
        }
        else if(questionNum == 4 && sender.tag == 2){
            newClient.fumante = "Não"
        }
        
        questionNum += 1
        nextQuestion()
        
    }
    
    func getDate () -> String{
        
        var day : String = ""
        var month : String = ""
        let date = datePicker.date as NSDate
        
        day = date.day.description
        month = date.month.description
        
        if(date.day < 10){
            day = "0\(date.day)"
        }
        if(date.month < 10){
            month = "0\(date.month)"
        }
        
        return day + "/" + month + "/\(date.year)"
    }

}

extension NSDate {
    var day: Int {
        return NSCalendar.current.component(.day,   from: self as Date)
    }
    var month: Int {
        return NSCalendar.current.component(.month,   from: self as Date)
    }
    var year: Int {
        return NSCalendar.current.component(.year,   from: self as Date)
    }
}

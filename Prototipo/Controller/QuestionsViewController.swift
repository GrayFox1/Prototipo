//
//  QuestionsViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 17/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    var questionNum : Int = 0
    let questionsArray : [String] = ["Qual é o seu nome?", "Quantos anos você tem?", "Quantos filhos?"]
    let newClient = Client()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.isHidden = true
        nextQuestion()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion (){
        
        if(questionNum < questionsArray.count){
            questionLabel.text = questionsArray[questionNum]
            updateView()
        }
        else{
            //Salvar dados no BD
            // Go Next View
        }
        
    }
    
    func updateView (){
        answerTextInput.text = ""
        progressLabel.text = "\(questionNum + 1) / \(questionsArray.count)"
        progressBar.frame.size.width = (view.frame.size.width / 3 ) * CGFloat(questionNum + 1)
        
        if(questionNum == 1){
            welcomeLabel.text = "Seja bem-vindo \(newClient.name)!😃"
            welcomeLabel.isHidden = false
        }
    }
    
    @IBAction func enviarAction(_ sender: UIButton) {
        
        let result = checkAnswer()
        
        if(result == true){
            switch(questionNum){
                
            case 0:
                newClient.name = answerTextInput.text!
            case 1:
                newClient.age = Int(answerTextInput.text!)!
            case 2:
                newClient.qtdFilhos = Int(answerTextInput.text!)!
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
    

}

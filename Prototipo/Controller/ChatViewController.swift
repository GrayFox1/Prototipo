//
//  ChatViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 01/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray = [Message]()
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        loadMessages()
        configureTableView()
    }
    
    func configureTableView (){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    @objc func tableViewTapped(){ //Remover teclado
        messageTextField.endEditing(true)
    }
    
    //MARK:  Métodos Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageLabel.text = messageArray[indexPath.row].messageText
        cell.senderName.text = messageArray[indexPath.row].sender
        cell.avatarImage.image = UIImage(named: "user" )
        
        if( cell.senderName.text == Auth.auth().currentUser?.email as String!) { //Minhas msgs
            cell.avatarImage.backgroundColor = FlatSkyBlue()
            cell.messageBackground.backgroundColor = FlatSkyBlue()
        }
        else{ //Msgs do corretor
            cell.avatarImage.backgroundColor = FlatWatermelon()
            cell.messageBackground.backgroundColor = FlatGray()
        }
        
        return cell
    }
    
    //MARK: Métodos Text Field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }

    }


    func textFieldDidEndEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        
        //Send the message to Firebase and save it in our database
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesBD = Database.database().reference().child("Messages")
        let messageDict = ["Email" : Auth.auth().currentUser?.email, "MessageText" : messageTextField.text!]
        
        messagesBD.childByAutoId().setValue(messageDict) {
            (error, reference) in
            
            if(error != nil){
                print(error!)
            }
            else{
                print("Mensagem salva no BD")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
            
        }
    }
    
    func loadMessages() {
        
        let messageBD = Database.database().reference().child("Messages")
        
        messageBD.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageText"]!
            let email = snapshotValue["Email"]!
            
            let message = Message()
            message.messageText = text
            message.sender = email
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
        
    }
    
}

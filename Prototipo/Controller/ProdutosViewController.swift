//
//  ProdutosViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 21/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase

class ProdutosViewController: UITableViewController {
    
    let produtosArray = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F"]
    var newClient = Client()
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.blue
    
        messageLabel.text = "\(newClient.nome), organizamos produtos personalizados para você! 😉"
     
    }
    
    // Métodos Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell (style: .default , reuseIdentifier : "ProdutoCell")
        
        cell.textLabel?.text = produtosArray[indexPath.row]
        
        return cell
    }
    
    // Métodos Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath , animated: true)
    }


    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        
        do{
            try Auth.auth().signOut()
            navigationController?.navigationBar.barTintColor = UIColor.lightGray
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("Error signing out")
        }
        
    }
    
}

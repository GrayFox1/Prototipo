//
//  ProdutosViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 21/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import RealmSwift

class ProdutosViewController: UITableViewController {
    
    let realm = try! Realm()
    let produtosArray = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F"]
    var newClient = Client()
    
    var produtos : Results<Produto>?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        self.navigationItem.hidesBackButton = true
        updateNavBar(withHexCode: FlatSkyBlue().hexValue())
        //navigationController?.navigationBar.barTintColor = FlatSkyBlue()
        messageLabel.text = "\(newClient.nome), organizamos produtos personalizados para você! 😉\nSelecione os produtos que te interessar :)"
        
        loadProdutos()
        
        if(produtos!.count == 0){
            do{
                try realm.write {
                    let newProduto = Produto()
                    newProduto.title = "Produto A"
                    realm.add(newProduto)
                    let newProduto2 = Produto()
                    newProduto2.title = "Produto B"
                    realm.add(newProduto2)
                    let newProduto3 = Produto()
                    newProduto3.title = "Produto C"
                    realm.add(newProduto3)
                    let newProduto4 = Produto()
                    newProduto4.title = "Produto D"
                    realm.add(newProduto4)
                    let newProduto5 = Produto()
                    newProduto5.title = "Produto E"
                    realm.add(newProduto5)
                    let newProduto6 = Produto()
                    newProduto6.title = "Produto F"
                    realm.add(newProduto6)
                    tableView.reloadData()
                }
            }
            catch{
                print("Erro ao salvar, \(error)")
            }
            loadProdutos()
        }
        
    }
    
    func loadProdutos (){
        
        produtos = realm.objects(Produto.self)
        tableView.reloadData()
    }
    
    func updateNavBar(withHexCode colorHexCode : String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller não existe")}
        guard let navBarColor = UIColor(hexString : colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
    }

    
    //MARK: Métodos Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell (style: .default , reuseIdentifier : "ProdutoCell")
        
        cell.textLabel?.text = produtos?[indexPath.row].title ?? "Sem Produtos :/"
        
        cell.accessoryType = (produtos?[indexPath.row].state)! ? .checkmark : .none
        
        let color = FlatBlue()
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        
        return cell
    }
    
    //MARK: Métodos Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let produto = produtos?[indexPath.row] {
            do{
                try realm.write {
                    produto.state = !produto.state
                }
            }
            catch{
                print("Erro ao atualizar dados, \(error)")
            }
            
        }
        
        tableView.deselectRow(at: indexPath , animated: true)
        tableView.reloadData()
    }

    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("Error signing out")
        }
        
    }
    
    
}

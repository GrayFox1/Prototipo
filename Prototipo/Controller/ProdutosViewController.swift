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
import SwipeCellKit

class ProdutosViewController: UITableViewController {
    
    let realm = try! Realm()
    let produtosArray = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F"]
    var newClient = Client()
    var produtos : Results<Produto>?
    var productIndex = -1
    
    
    
    @IBOutlet var concluirButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
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
    
    //MARK: Métodos Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutoCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = produtos?[indexPath.row].title ?? "Sem Produtos :/"
        cell.accessoryType = (produtos?[indexPath.row].state)! ? .checkmark : .none
        
        let color = FlatOrange()
        cell.backgroundColor = color
        cell.tintColor = FlatWhite()
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        
        cell.delegate = self
        
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
        if(self.navigationItem.rightBarButtonItem == nil){
            self.navigationItem.rightBarButtonItem = self.concluirButton
        }
        productIndex = indexPath.row
        
        tableView.deselectRow(at: indexPath , animated: true)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToInfoView"){
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.productIndex = self.productIndex
        }
        else if(segue.identifier == "goToRegisterView"){
            let destinationVC2 = segue.destination as! RegisterViewController
            destinationVC2.newClient = self.newClient
        }
    }
    
    
    @IBAction func concluirAction(_ sender: UIBarButtonItem) {
        
        if(productIndex != -1){
            performSegue(withIdentifier: "goToRegisterView", sender: self)
        }
    }
    
    
}
    
extension ProdutosViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let infoAction = SwipeAction(style: .default, title: "Info") { action, indexPath in
            self.performSegue(withIdentifier: "goToInfoView", sender: self)
            
        }
        productIndex = indexPath.row
        infoAction.image = UIImage(named: "info2")
        
        return [infoAction]
    }
}


//    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
//
//        do{
//            try Auth.auth().signOut()
//            navigationController?.popToRootViewController(animated: true)
//        }
//        catch{
//            print("Error signing out")
//        }
//
//    }
    


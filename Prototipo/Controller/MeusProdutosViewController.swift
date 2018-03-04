//
//  MeusProdutosViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 04/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import ChameleonFramework

class MeusProdutosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var client : Client?

    @IBOutlet var favoritosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritosTableView.rowHeight = 80.0
        favoritosTableView.delegate = self
        favoritosTableView.dataSource = self
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(client?.produtosSelected.count == 0){
            return 1
        }
        return client?.produtosSelected.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutoCell", for: indexPath)
        let produtos = client?.produtosSelected
        if(produtos?.count == 0){
            cell.textLabel?.text = "Sem Favoritos :("
        }
        else{
            cell.textLabel?.text = produtos?[indexPath.row]
        }

        let color = FlatOrange()
        cell.backgroundColor = color
        cell.tintColor = FlatWhite()
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        
        return cell
    }
    
    //MARK: Métodos Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

   
}

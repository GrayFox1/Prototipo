//
//  MainViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 01/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let empresaImages = ["empresa1", "empresa2", "empresa3"]
    var updateCounter = 0
    var timer : Timer?

    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.tabBarController?.tabBar.isHidden == true){
            self.tabBarController?.tabBar.isHidden = false
        }
        
        infoImage.image = UIImage(named: "empresa1")
        updateCounter = 0
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if(updateCounter < 2){
            updateCounter += 1
        }
        else{
            updateCounter = 0
        }
        infoImage.image = UIImage(named: empresaImages[updateCounter])
        pageControl.currentPage = updateCounter
    }
    
    
}
